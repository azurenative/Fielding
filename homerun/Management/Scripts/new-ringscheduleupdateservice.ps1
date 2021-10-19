<#
    .SYNOPSIS
    This script will deploy Update management Ring schedule for Windows ONLY

    .PARAMETER resourceGroupName
    the resource group name where the Automation Account lives in.

    .PARAMETER templateFilePath
    the arm template that contains Windows deployment schedule.

    .PARAMETER subscriptionId
    the subscription id based on region deployment
#>

[CmdletBinding()]
param (
  [parameter(Mandatory=$true)]
  [string] $artifactPath,

  [parameter(Mandatory)]
  [bool] $isProduction,

  [parameter(Mandatory)]
  [bool] $isWorkload,

  [parameter(Mandatory=$true)]
  [string] $resourceGroupName,

  [parameter(Mandatory=$true)]
  [string] $subscriptionId
)

Select-AzSubscription -Subscription $subscriptionId
Install-Module -Name Az.ResourceGraph -Force
Install-Module -Name Az.OperationalInsights -Force
Import-Module -Name Az.ResourceGraph -Force
Import-Module -Name Az.OperationalInsights -Force

#$VerbosePreference = "continue"
try {
  $resourceGroupLocation = Get-AzResource -ResourceGroupName $resourceGroupName | where-object Location -ne "global" | select-object -ExpandProperty Location
  if(!$resourceGroupLocation) {
    Write-Warning -Message "could not get resourcegroup location [$resourceGroupLocation]" -Verbose
  }
  $automationAccountName = (Get-AzResource -ResourceGroupName $resourceGroupName -ResourceType "microsoft.automation/automationaccounts" ).Name
  if(!$automationAccountName) {
    Write-Warning -Message "Could not find the automation account name [$automationAccountName]" -Verbose
  }
    
  if(!$isWorkload -and (!$isProduction)) {
    $scheduleName = "deploymentupdateservice-Windows-ring0"
    $WeekInterval = 1
    $startTime = (Get-Date "01:00:00").AddDays(1)
    $ScopeQueryRing = @"
        resourcecontainers
        | where type =~ 'microsoft.resources/subscriptions'
        | where tags.isProduction contains "false" and tags.isWorkload contains "false"
"@
  }
  elseif($isWorkload -and (!$isProduction)) {
    $scheduleName = "deploymentupdateservice-Windows-ring1-workload"
    $WeekInterval = 2
    $startTime = (Get-Date "01:00:00").AddDays(7)
    $ScopeQueryRing = @"
        resourcecontainers
        | where type =~ 'microsoft.resources/subscriptions'
        | where tags.isProduction contains "false" and tags.isWorkload contains "true"
"@
  }
  elseif(!$isWorkload -and ($isProduction)) {
    $scheduleName = "deploymentupdateservice-Windows-ring1-prod"
    $WeekInterval = 2
    $startTime = (Get-Date "01:00:00").AddDays(7)
    $ScopeQueryRing = @"
        resourcecontainers
        | where type =~ 'microsoft.resources/subscriptions'
        | where tags.isProduction contains "true" and tags.isWorkload contains "false"
"@
  }
  elseif($isProduction -and $isWorkload) {
    $scheduleName = "deploymentupdateservice-Windows-ring2"
    $WeekInterval = 3
    $startTime = (Get-Date "01:00:00").AddDays(14)
    $ScopeQueryRing = @"
        resourcecontainers
        | where type =~ 'microsoft.resources/subscriptions'
        | where tags.isProduction contains "true" and tags.isWorkload contains "true"
"@
  }
  #region Create Ring Schedule Update Management
  $SubscriptionScope = (Search-AzGraph -Query $ScopeQueryRing -ErrorAction Stop -Verbose).Data | Select-Object -ExpandProperty ResourceId
  if(!$SubscriptionScope) {
    Write-Warning -Message "[$SubscriptionScope] is empty" -Verbose
  }
  Write-Verbose -Message "Ring schedule set for ring [$scheduleName]"
  $automationScheduleArgs = @{
    'AutomationAccountName' = $automationAccountName
    'FilterOperator'        = "All"
    'Location'              = $resourceGroupLocation
    'ResourceGroupName'     = $resourceGroupName
    'Scope'                 = $SubscriptionScope
  }
   
  $UpdateManagementAzureQuery = New-AzAutomationUpdateManagementAzureQuery @automationScheduleArgs -ErrorAction Stop
  if(!$UpdateManagementAzureQuery) {
    Write-Warning -Message "[$UpdateManagementAzureQuery] is empty" -Verbose
  }

  $automationScheduleArgs = @{
    'AutomationAccountName'  = $automationAccountName
    'DaysOfWeek'             = "Wednesday"
    'ForUpdateConfiguration' = $true
    'Name'                   = $scheduleName
    'ResourceGroupName'      = $resourceGroupName
    'StartTime'              = $startTime
    'TimeZone'               = "Europe/Amsterdam"
    'WeekInterval'           = $WeekInterval
  }
  $automationSchedule = New-AzAutomationSchedule @automationScheduleArgs -ErrorAction Stop #TMP: Force new schedule
  Write-Verbose -Message "Ring schedule created for ring [$scheduleName]" -Verbose
  #endregion

  #region get workspaceId per region
  $lawsQ = @"
    resources
    | where type == "microsoft.operationalinsights/workspaces"
    | where name matches regex "LAW-AZP"
    | where resourceGroup matches regex "logmanagement"
"@
  $laws = Search-AzGraph -Query $lawsQ -Subscription $subscriptionId    
  $AutomationAccountName = (Get-AzAutomationAccount -ResourceGroupName $resourceGroupName).AutomationAccountName
  $workSpaceAccountName = $automationAccountName.Replace("AUTOM", "LAW")
  foreach($law in $laws.Data) {
    if($workSpaceAccountName -eq $law.name) {
      $workspaceId = $law.properties.customerId
    }
  }
  if(!$workspaceId) {
    Write-Verbose -Message "workspaceId [$workspaceId] could not be found or is empty" -Verbose
  }
  #endregion

  #region create kb list based on tagged subscriptions
  $query = @"
    Update
    | where OSType !="Linux" and Optional==false
    | where Classification has "UpdateRollup" or Classification has "FeaturePack" or Classification has "ServicePack" or Classification has "Definition" or Classification has "Tools" or Classification has "Updates"
    | summarize arg_max(TimeGenerated, *) by Computer,SourceComputerId,UpdateID, ApprovalSource, KBID
    | summarize hint.strategy=partitioned arg_max(TimeGenerated, *) by KBID
    | where UpdateState=~"Needed" and Approved!=false
    | project KBID, Title
"@
  Write-Verbose -Message "Set KB list for Ring Schedule [$scheduleName]" -Verbose
  $kbQuery = Invoke-AzOperationalInsightsQuery -Query $query -WorkspaceId $workspaceId -ErrorAction Stop
  foreach($kb in $kbQuery.Results) {
    $kblist += @($kb.KBID)
  }

  #region create kb artifact
  $kbArtifactName = "kblist.txt"
  $pathExist = Test-Path -Path "$artifactPath\KB\$kbArtifactName"
  if(!$pathExist)
  {    
    Write-Verbose -Message "Create KB set artifact [$kbArtifactName]" -Verbose
    New-Item -ItemType Directory -Name "KB" -Path $artifactPath
    $kblist | Out-File -FilePath  "$artifactPath\KB\$kbArtifactName" -Verbose
    Write-Verbose -Message "[$($kbList.count)] non-critical updates" -Verbose   
  }
  else 
  {
    Write-Verbose -Message "Get KB set [$kbArtifactName]" -Verbose
    $kbList = Get-Content -Path "$artifactPath\KB\$kbArtifactName"
    Write-Verbose -Message "[$($kbList.count)] non-critical updates" -Verbose
  }
    Write-Verbose -Message "KB list succesfull configured for Ring Schedule [$scheduleName]" -Verbose
  #endregion

  #region Deploy Update Management Schedules
  $updateArgs = @{      
    'AutomationAccountName' = $automationAccountName
    'AzureQuery'            = $UpdateManagementAzureQuery
    'duration'              = New-TimeSpan -Hours 2
    'IncludedKbNumber'      = $kbList
    'RebootSetting'         = "IfRequired"
    'ResourceGroupName'     = $resourceGroupName
    'Schedule'              = $automationSchedule
    'Windows'               = $true      
  }
  Write-Verbose -Message "Deploy Ring Schedule [$scheduleName]" -Verbose
  New-AzAutomationSoftwareUpdateConfiguration @updateArgs -ErrorAction stop  
  #endregion
}
catch {
  $errorMessage = $_.Exception.Message + "At Line number: $($_.InvocationInfo.ScriptLineNumber)"
  throw $errorMessage
}