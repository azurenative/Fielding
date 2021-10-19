<#
    .SYNOPSIS
    This script will deploy Update management schedule for Windows and Linux

    .PARAMETER resourceGroupName
    the resource group name where the Automation Account lives in.

    .PARAMETER templateFilePath
    the arm template that contains Windows and Linux deployment schedule.

    .PARAMETER subscriptionId
    the subscription id based on region deployment
#>

[CmdletBinding()]
param (

  [parameter()]
  [ValidateSet('Windows', 'Linux')]
  [System.String[]] $OperatingSystem = @('Windows', 'Linux'),

  [Parameter(mandatory)]
  [string] $resourceGroupName,

  [Parameter(mandatory)]
  [string] $templateFilePath,

  [Parameter(mandatory)]
  [string] $subscriptionId
)

Select-AzSubscription -Subscription $subscriptionId
Install-Module -Name Az.ResourceGraph -Force
Import-Module -Name Az.ResourceGraph -Force

try {
  foreach ($os in $OperatingSystem) 
  {
   
    $resourceGroupLocation = (Get-AzResource -ResourceGroupName $resourceGroupName).Location
    if (!$resourceGroupLocation) {
      Write-Warning -Message "could not get resourcegroup location [$resourceGroupLocation]"
    }
    $automationAccountName = (Get-AzResource -ResourceGroupName $resourceGroupName -ResourceType "microsoft.automation/automationaccounts" ).Name
    if (!$automationAccountName) {
      Write-Warning -Message "Could not find the automation account name [$automationAccountName]"
    }
  
    #region Create Azure Query for deployment schedule
    $azQuery = @"
resourcecontainers
| where type == 'microsoft.resources/subscriptions'
| project ResourceId=id
"@
  
    $AzureQuery = (Search-AzGraph -Query $azQuery -ErrorAction Stop).Data | Select-Object -ExpandProperty ResourceId    
    if (!$AzureQuery) 
    {
      Write-Warning -Message "[$AzureQuery] is empty"
    }
    
    #endregion

    #region Deploy Update Management Schedules
    $scheduleName ="deploymentupdateservice-$($os)-all"
      $updateArgs = @{
        AutomationAccountName        = $automationAccountName
        duration                     = "PT2H"
        frequency                    = "Week"
        osType                       = $os  
        locationFilter               = @($resourceGroupLocation)
        rebootSetting                = "IfRequired"      
        startTime                    = (Get-Date "01:00:00").AddDays(1)
        scheduleName                 = $scheduleName
        scopeFilter                  = $AzureQuery
        weekDays                     = "Thursday"
      }
      Write-Verbose -Message "Deploy update service schedule for [$os]-[$resourceGroupLocation]" -Verbose      
      New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
        -TemplateFile "$templateFilePath\updateService$os.json" `
        -TemplateParameterObject $updateArgs `
        -Name "updateservice$($os)deployment"
  }
    #endregion
}
catch 
{
  $errorMessage = $_.Exception.Message + "At Line number: $($_.InvocationInfo.ScriptLineNumber)"
  throw $errorMessage
}