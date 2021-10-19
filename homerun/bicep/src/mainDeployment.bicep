targetScope = 'subscription'

param location string
param logManagementResourceGroupName string
param logAnalyticsName string

resource myresourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: logManagementResourceGroupName
  location: location
}


module logAnalytics './modules/logAnalytics.bicep' = {
  name: 'LogAnalytics'
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
