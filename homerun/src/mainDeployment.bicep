targetScope = 'subscription'

param location string
param logManagementResourceGroupName string
param logAnalyticsName string

resource ResourceGroupLogManagement 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: logManagementResourceGroupName
  location: location
}

module logAnalytics './modules/logAnalytics.bicep' = {
  name: 'LogAnalytics'
  dependsOn: [
    ResourceGroupLogManagement
  ]
  scope: resourceGroup(logManagementResourceGroupName)
  params: {
    logAnalyticsName: logAnalyticsName
  }
}

module workbookDashboard './modules//workbookDashboardView.bicep' = {
  name: 'workbookDashboardView_APT'
  scope: resourceGroup(logManagementResourceGroupName)
  params: {
    workbookDisplayName: 'workbook_Dashboard_View_apt'
    workbookSourceId: 'azure monitor'
    workbookType: 'workbook'
  }
}
