targetScope = 'subscription'

param location string
param logManagementResourceGroupName string
param logAnalyticsName string

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
