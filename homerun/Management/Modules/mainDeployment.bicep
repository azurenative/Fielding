targetScope = 'subscription'

var monitorContributorRoleDefinitionId = '/providers/Microsoft.Authorization/roledefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
var readerAndDataAccessRoleDefinitionId = '/providers/Microsoft.Authorization/roledefinitions/c12c1c16-33a1-487b-954d-41c89c60f349'
var netWorkContributorId = '/providers/Microsoft.Authorization/roledefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'

var workbookResourceGroup = azureEnvironment == 'prod' ? 'LogManagement.WestEurope' : 'LogManagement.WestEurope.Test'

param managedIdentityName string
param location string
param azureEnvironment string

param connectivityResourceGroupName string
param connectivitySubscriptionId string

param virtualNetworkResourceGroupName string

param virtualNetworkName string
param virtualNetworkAddressPrefix string
param sharedServicesSubnetAddressPrefix string

var sharedServicesSubnetName = 'SharedServicesSubnet'
var networkSecurityGroupName = sharedServicesSubnetName

param actionGroupShortName string
param actionGroupLocation string
param secretManagementResourceGroupName string
param logManagementResourceGroupName string
param logManagementActionGroupName string
param logManagementActionGroupShortName string
param managedIdentitiesResourceGroupName string
param fileStagingResourceGroupName string
param fileStagingstorageAccountName string
param updateManagementResourceGroupName string
param updateManagementGroupName string
param actionGroupname string
param alertName string
param logAnalyticsName string
param storageAccountName string
param automationAccountName string
param sharedDashboardName string
param updateManagementName string
param workbookDisplayName string
param keyVaultNameD string = ''
param keyVaultNameR string = ''
param accessPolicies array = []

param deploymentDateTime string = utcNow()

resource ResourceGroupConnectivity 'Microsoft.Resources/resourceGroups@2020-06-01' existing = {
  name: connectivityResourceGroupName
  scope: subscription(connectivitySubscriptionId)
}

resource ResourceGroupVirtualNetwork 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: virtualNetworkResourceGroupName 
  location: location
}

resource ResourceGroupSecretManagement 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: secretManagementResourceGroupName
  location: location
}

resource ResourceGroupLogAnalytics 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: logManagementResourceGroupName
  location: location
}

resource ResourceGroupManagedIdentity 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: managedIdentitiesResourceGroupName
  location: 'westeurope'
}

resource ResourceGroupFileStaging 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: fileStagingResourceGroupName
  location: location
}

resource ResourceGroupUpdateManagement 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: updateManagementResourceGroupName
  location: location
}


module securityCenter '../../Shared/Modules/securityCenter.bicep' = {
  name: 'SecurityCenter-${deploymentDateTime}'
  scope: subscription()
}

module networkSecurityGroup '../../Shared/Modules/networkSecurityGroup.bicep' = {
  name: 'NetworkSecurityGroup-${deploymentDateTime}'
  dependsOn: [
    ResourceGroupVirtualNetwork
  ]
  scope: ResourceGroupVirtualNetwork
  params: {
    networkSecurityGroupName: networkSecurityGroupName
  }
}

module virtualNetwork '../../Shared/Modules/virtualNetwork.bicep' = {
  name: 'VirtualNetwork-${deploymentDateTime}'
  dependsOn: [
    networkSecurityGroup
  ]
  scope: ResourceGroupVirtualNetwork
  params: {    
    networkSecurityGroupName: networkSecurityGroupName
    sharedServicesSubnetAddressPrefix: sharedServicesSubnetAddressPrefix
    sharedServicesSubnetName: sharedServicesSubnetName
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
    virtualNetworkName: virtualNetworkName    
  }
}

module privateDnsDeployment '../../Shared/Modules/privateDnsDeployment.bicep' = {
  name: 'PrivateDnsZonesAndLinks-${deploymentDateTime}'
  dependsOn: [
    virtualNetwork
  ]
  scope: ResourceGroupVirtualNetwork
  params: {
    linkName: 'to-Hub'
    virtualNetworkResourceId: virtualNetwork.outputs.virtualNetworkResourceId
  }
}

module storageAccount './storageAccount.bicep' = {
  name: 'StorageAccount-${deploymentDateTime}'
  dependsOn: [
    ResourceGroupLogAnalytics
  ]
  scope: ResourceGroupLogAnalytics
  params: {
    storageAccountName: storageAccountName
  }
}

module fileStagingStorageAccount './storageAccount.bicep' = if (location == 'westeurope') {
  name: 'fileStagingStorageAccount' 
  scope: ResourceGroupFileStaging
  dependsOn: [
    ResourceGroupFileStaging
  ]
  params: {
    storageAccountName: fileStagingstorageAccountName
  }
}

module keyVault './keyVault.bicep' = if (location == 'westeurope') {
  name: 'KeyVault-${deploymentDateTime}'
  dependsOn: [
    ResourceGroupSecretManagement
    logAnalytics
  ]
  scope: resourceGroup(secretManagementResourceGroupName)
  params: {
    location: location
    environment: azureEnvironment
    keyVaultNameD: keyVaultNameD
    keyVaultNameR: keyVaultNameR
    accessPolicies: accessPolicies
    workspaceResourceId: logAnalytics.outputs.LogAnalyticsId
  }
}

module privateEndpointsWestEuropeOnly '../../Shared/Modules/privateEndpointsDeployment.bicep' = if(location == 'westeurope') {
  name: 'PrivateEndpointsWestEurope-${deploymentDateTime}'
  dependsOn:[    
    fileStagingStorageAccount
    keyVault
  ]  
  params: {
    subnetName: sharedServicesSubnetName
    virtualNetworkName: virtualNetworkName
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    resources: [      
      {
        id: location == 'westeurope' ? fileStagingStorageAccount.outputs.resourceId : ''
        name: fileStagingstorageAccountName
        resourceGroupName: fileStagingResourceGroupName
        dnsZoneName: privateDnsDeployment.outputs.file
        groupIds:[
          'file'
        ]
      }
      {
        id: location == 'westeurope' ? keyVault.outputs.deployTimeKeyVaultId : ''
        name: keyVaultNameD
        resourceGroupName: secretManagementResourceGroupName
        dnsZoneName: privateDnsDeployment.outputs.vault
        groupIds:[
          'vault'
        ]
      }
      {
        id: location == 'westeurope' ? keyVault.outputs.runTimeKeyVaultId : ''   
        name: keyVaultNameR
        resourceGroupName: secretManagementResourceGroupName
        dnsZoneName: privateDnsDeployment.outputs.vault
        groupIds:[
          'vault'
        ]
      }
    ]
  }
}

module privateEndpointsWestAndNorthEurope '../../Shared/Modules/privateEndpointsDeployment.bicep' = {
  name: 'PrivateEndpointsWestAndNorthEurope-${deploymentDateTime}'
  dependsOn: [
    storageAccount
  ]
  params: {
    subnetName: sharedServicesSubnetName
    virtualNetworkName: virtualNetworkName
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    resources: [
      {
        id: storageAccount.outputs.resourceId        
        name: storageAccountName
        resourceGroupName: logManagementResourceGroupName
        dnsZoneName: privateDnsDeployment.outputs.blob
        groupIds:[
          'blob'
        ]
      }
    ]
  }  
}

module managedIdentity './managedIdentity.bicep' = {
  name: 'ManagedIdentity-${deploymentDateTime}'
  scope: ResourceGroupManagedIdentity
  params: {
    managedIdentityName: managedIdentityName
  }
  dependsOn: [
    ResourceGroupManagedIdentity
  ]
}

module logAnalytics './logAnalytics.bicep' = {
  name: 'LogAnalytics-${deploymentDateTime}'
  scope: ResourceGroupLogAnalytics
  params: {
    logAnalyticsName: logAnalyticsName
    UpdateManagementName: updateManagementName
    logManagementActionGroupName:logManagementActionGroupName
    logManagementActionGroupShortName:logManagementActionGroupShortName
  }
  dependsOn: [
    ResourceGroupLogAnalytics
  ]
}

module logManagementRoleAssignment './logManagementRoleAssignment.bicep' = {
  name: 'LogManagementRoleAssignment-${deploymentDateTime}'
  scope: ResourceGroupLogAnalytics
  params: {
    roleAssignmentScope: ResourceGroupLogAnalytics.id
    monitorContributorRoleDefinitionId: monitorContributorRoleDefinitionId
    readerAndDataAccessRoleDefinitionId: readerAndDataAccessRoleDefinitionId
    managedIdentityResourceId: managedIdentity.outputs.managedIdentityId
  }
  dependsOn: [
    managedIdentity
    ResourceGroupLogAnalytics
  ]
}

module HubToSpokePeeringRoleAssignment './hubToSpokePeeringRoleAssignment.bicep' = {
  name: 'HubToSpokePeeringRoleAssignment-${deploymentDateTime}'
  scope: ResourceGroupConnectivity
  params: {
    roleDefinitionId: netWorkContributorId
    managedIdentityResourceId: managedIdentity.outputs.managedIdentityId
  }
  dependsOn: [
    managedIdentity
  ]
}

module automationAccount './automationAccount.bicep' = {
  name: 'AutomationAccount-${deploymentDateTime}'
  dependsOn: [
    ResourceGroupUpdateManagement
  ]
  scope: resourceGroup(updateManagementResourceGroupName)
  params: {
    automationAccountName: automationAccountName
  }
}

module linkedService './linkedService.bicep' = {
  name: 'LinkedService-${deploymentDateTime}'
  scope: resourceGroup(logManagementResourceGroupName)
  dependsOn: [
    logAnalytics
    automationAccount
  ]
  params: {
    logAnalyticsWorkSpaceName: '${logAnalytics.outputs.LogAnalyticsName}/Automation'
    automationAccountId: automationAccount.outputs.automationAccountUpdateManagementId
  }
}

module workbookView './workbookView.bicep' = {
  name: 'workbookDeployment-${deploymentDateTime}'
  scope: resourceGroup(workbookResourceGroup)
  params: {
    workbookDisplayName: workbookDisplayName
    workbookSourceId: logAnalytics.outputs.LogAnalyticsId
    workbookType: 'workbook'
    location: location
  }
  dependsOn: [
    logAnalytics
  ]
}

module sharedDashboard './sharedDashboard.bicep' = {
  name: 'sharedDashboardDeployment-${deploymentDateTime}'
  scope: resourceGroup(workbookResourceGroup)
  params: {
    workbookDisplayName: workbookDisplayName
    logAnalyticsId: logAnalytics.outputs.LogAnalyticsId
    sharedDashboardName: sharedDashboardName
    workbookResourceId: workbookView.outputs.workbookResourceId
    location: location
    logAnalyticsName: logAnalytics.outputs.LogAnalyticsName
    logManagementResourceGroupName: ResourceGroupLogAnalytics.name
  }
  dependsOn: [
    workbookView
  ]
}

module updateManagementAlerts 'updateManagementAlerts.bicep' = {
  name: 'UpdateManagementAlerts-${deploymentDateTime}'
  scope: resourceGroup(updateManagementResourceGroupName)
  params: {
    actionGroupLocation: actionGroupLocation
    actionGroupName: actionGroupname
    actionGroupShortName: actionGroupShortName
    alertName: alertName
    automationAccountID: automationAccount.outputs.automationAccountUpdateManagementId
    automationAccountName: automationAccountName
    updateManagementGroupName: updateManagementGroupName
  }
}
output updateManagementGroupName string = ResourceGroupUpdateManagement.name
