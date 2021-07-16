#---------------------------------------------------------------------------------
# Script: deploy-accessmanagement.ps1
# Description: This script will deploy Azure Lighthouse with Assignable Security PIM Groups
# Author:      Joe Tahsin
# Copyright (C) 2020 INFIELD
#---------------------------------------------------------------------------------
# 23-09-2020- 0.1 - Joe Tahsin: First Version
#---------------------------------------------------------------------------------
[CmdletBinding()]
param (
    [Parameter(mandatory = $true)]
    [string]$Customer,

    [Parameter(Mandatory = $true, HelpMessage = "application id of the deployment account")]
    [ValidateNotNullOrEmpty()]
    [string]$clientid,

    [Parameter(Mandatory = $true, HelpMessage = "application secret of the deployment account")]
    [ValidateNotNullOrEmpty()]
    [string]$clientsecret,

    [Parameter(Mandatory = $true, HelpMessage = "identifier of the CUSTOMER Tenant")]
    [ValidateNotNullOrEmpty()]
    [string]$customerId,

    [Parameter(Mandatory = $true, HelpMessage = "refreshtoken of the deployment account")]
    [ValidateNotNullOrEmpty()]
    [string]$refreshtoken,

    [Parameter(Mandatory = $false, HelpMessage = "switch for resource group deployment")]
    [ValidateNotNullOrEmpty()]
    [switch]$resourceGroup,

    [Parameter(Mandatory = $false, HelpMessage = "switch for subscription deployment")]
    [ValidateNotNullOrEmpty()]
    [switch]$Subscription,

    [Parameter(Mandatory = $false, HelpMessage = "ObjectId of the SPN deploy account")]
    [string]$spnObjectId, #this is the object ID of the onboarding deploy account

    [Parameter(Mandatory = $true, HelpMessage = "tenant id of MSP provider")]
    [string]$tenantId

)

$Modules = "Az.Accounts", "Az.Resources", "AzureADPreview"
Foreach ($Module in $Modules)
{
    if (Get-Module -ListAvailable -Name $Module)
    {
        Write-Host "Module exists $Module" -BackgroundColor Green -ForegroundColor Yellow
    }
    else
    {
        Write-Host "Module does not exist. importing module" -BackgroundColor Red -ForegroundColor Yellow
        import-module .\Modules\Az.Accounts -force
        Import-Module .\Modules\AzureADpreview -force
        import-module .\Modules\ASAP-Helper -force
        Import-Module .\Modules\Az.Resources -RequiredVersion 2.5.1 -Force
    }
}
try
{

    Write-Output "Create new security Groups" -verbose
    $rbacObject = New-SecurityPIMGroups -clientId $clientId `
        -Customer $Customer `
        -clientSecret $clientSecret `
        -RefreshToken $RefreshToken `
        -spnObjectId $spnObjectId `
        -tenantId $tenantId `
        -Verbose
    Write-Output "## session New-SecurityPIMGroups finished ##" -verbose
    start-sleep -Seconds 15


    # connect here with the Master SPN of the customer tenant id
    # below will deploy the Azure Lighthouse ARM Template


    Write-Output "## successfull connected with Azure API ##" -verbose
    write-output "initiate azure lighthouse deployment" -verbose
    #step 1 get RBAC object
    if (!$rbacObject)
    {
        Write-Output "the rbac object is empty"
        throw $_.exception
    }
    $SubscriptionAccess = @($rbacObject.admins, $rbacObject.automation)
    $ResourceGroupAccess = @($rbacObject.ops)
    Write-Output $SubscriptionAccess -verbose
    Write-Output $ResourceGroupAccess -verbose
$Subscription = $true
    if ($Subscription)
    {
        Write-Output "## initiate subscription deployment ##" -verbose
        $ParameterSubscription = @{
            "mspOfferName"        = "INFIELD - Cloud Expert Center Subscription"
            "mspOfferDescription" = "INFIELD - Cloud Center Excellence Premier Support"
            "managedByTenantId"   = "148c1134-991e-465c-bdbe-aae05c8953bf"
            "authorizations"      = $SubscriptionAccess
        }
        New-AzSubscriptionDeployment -TemplateUri "https://raw.githubusercontent.com/ASAPCLOUDGIT/templates/master/delegate-subscription.json" `
            -TemplateParameterObject $ParameterSubscription `
            -Location "westeurope" `
            -Name "AzureLightHouseSubscription" `
            -ErrorAction Stop `
            -verbose
        $currenttime = get-date
        write-host "Subscription deployment finished:  $currenttime"
    }
    elseif ($ResourceGroup)
    {
        Write-Output "## initiate resourcegroup deployment ##" -verbose
        #region create resourcegroup object
        $rgObjects = Get-AzResourceGroup -Location 'westeurope' | Select-Object ResourceGroupName

        #region declare array of rgs of hashes
        $rgGroups = @(); #new array object
        for ($i = 0; $i -lt $rgObjects.ResourceGroupName.count; $i++)
        {
            $hash = @{
                rgName = $rgObjects.ResourceGroupName[$i];
            }
            # add hash to array of rg hashes
            $rgGroups += $hash;
        }
        #endregion
        #endregion
        $ParameterResourceGroups = @{
            "mspOfferName"        = "Infield - Cloud Center Excellence ResourceGroups"
            "mspOfferDescription" = "INFIELD - Cloud Center Excellence Premier Support"
            "managedByTenantId"   = "148c1134-991e-465c-bdbe-aae05c8953bf"
            "resourceGroups"      = $rgGroups
            "authorizations"      = $ResourceGroupAccess
        }
        New-AzSubscriptionDeployment -TemplateUri "https://raw.githubusercontent.com/INFIELDGIT/templates/master/delegate-multi-rg.json" `
            -TemplateParameterObject $ParameterResourceGroups `
            -Location "westeurope" `
            -Name "AzureLightHouseResourceGroups" `
            -ErrorAction Stop `
            -verbose
        $currenttime = get-date
        write-host "resource group deployment finished:  $currenttime"
    }
    else
    {
        #region parameter object for subscription deployment
        $ParameterSubscription = @{
            "mspOfferName"        = "INFIELD - Cloud Expert Center Subscription"
            "mspOfferDescription" = "INFIELD - Cloud Center Excellence Premier Support"
            "managedByTenantId"   = "148c1134-991e-465c-bdbe-aae05c8953bf"
            "authorizations"      = $SubscriptionAccess
        }
        #endregion
        New-AzSubscriptionDeployment -TemplateUri "https://raw.githubusercontent.com/INFIELDGIT/templates/master/delegate-subscription.json" `
            -TemplateParameterObject $ParameterSubscription `
            -Location "westeurope" `
            -Name "AzureLightHouseSubscription" `
            -ErrorAction Stop `
            -Verbose
        $currenttime = get-date
        write-host "#############  Subscription Access deployment finished successfully:  $currenttime  ###########"
        start-sleep -Seconds 5
        #region create resourcegroup object
        write-host "#############  Starting Resource Group Access deployment:  $currenttime  ###########"
        $rgObjects = Get-AzResourceGroup -Location 'westeurope' | Select-Object ResourceGroupName

        #region declare array of rgs of hashes
        $rgGroups = @(); #new array object
        for ($i = 0; $i -lt $rgObjects.ResourceGroupName.count; $i++)
        {
            $hash = @{
                rgName = $rgObjects.ResourceGroupName[$i];
            }
            # add hash to array of rg hashes
            $rgGroups += $hash;
        }
        #endregion
        #endregion

        #region parameter object for resourcegroups deployment
        $ParameterResourceGroups = @{
            "mspOfferName"        = "INFIELD - Cloud Expert Center ResourceGroups"
            "mspOfferDescription" = "INFIELD - Cloud Center Excellence Premier Support"
            "managedByTenantId"   = "148c1134-991e-465c-bdbe-aae05c8953bf"
            "resourceGroups"      = $rgGroups
            "authorizations"      = $ResourceGroupAccess
        }
        #endregion

        New-AzSubscriptionDeployment -TemplateUri "https://raw.githubusercontent.com/INFIELDGIT/templates/master/delegate-multi-rg.json" `
            -TemplateParameterObject $ParameterResourceGroups `
            -Location "westeurope" `
            -Name "AzureLightHouseResourceGroups" `
            -ErrorAction Stop `
            -Verbose
        $currenttime = get-date
        write-host "#############  Resource Group Access deployment finished successfully:  $currenttime  ###########"
    }
}
catch
{
    $errorMessage = $_.Exception.Message + "`nAt Line number: $($_.InvocationInfo.ScriptLineNumber)"
    throw $errorMessage
}

