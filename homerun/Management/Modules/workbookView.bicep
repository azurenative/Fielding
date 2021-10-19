@description('The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group.')
param workbookDisplayName string

@description('The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is \'workbook\'')
param workbookType string

@description('The id of resource instance to which the workbook will be associated')
param workbookSourceId string

param location string
// objectid of azure ad group pbg-azureplatform-engineer
var azureplatformEngineer = 'd14b006f-f50c-4239-840c-0f0724e428f9'

// roledefinition (guid) of Monitoring Reader role
var MonitoringReader = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/43d0d8ad-25c7-4714-9337-8ba259a9fe05'

resource workbookId_resource 'microsoft.insights/workbooks@2018-06-17-preview' = {
  name: guid(workbookDisplayName)
  location: location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    serializedData: '{"version": "Notebook/1.0","items": [ {"type": 3,"content": { "version": "KqlItem/1.0", "query": "Perf\\r\\n| where TimeGenerated > ago(5min)\\r\\n| where (ObjectName == \\"LogicalDisk\\" or ObjectName == \\"LogicalDisk\\") and CounterName contains \\"%\\" and InstanceName != \\"_Total\\" and InstanceName != \\"HarddiskVolume1\\"\\r\\n| project TimeGenerated, Computer, ObjectName, CounterName, InstanceName, CounterValue \\r\\n| summarize arg_max(TimeGenerated, *) by Computer\\r\\n| top 10 by CounterValue desc", "size": 4, "title": "Free disk space % by Computer", "timeContext": {"durationMs": 86400000 }, "queryType": 0, "resourceType": "microsoft.operationalinsights/workspaces", "visualization": "tiles", "tileSettings": {"showBorder": false,"titleContent": { "columnMatch": "Computer", "formatter": 1},"leftContent": { "columnMatch": "CounterValue", "formatter": 12, "formatOptions": {"palette": "auto" }, "numberFormat": {"unit": 17,"options": { "maximumSignificantDigits": 3, "maximumFractionDigits": 2} }} }},"showPin": true,"name": "Free disk space % by Computer" }, {"type": 3,"content": { "version": "KqlItem/1.0", "query": "Heartbeat\\r\\n| summarize arg_max(TimeGenerated, *) by Computer", "size": 4, "title": "Last HeartBeat by Computer", "timeContext": {"durationMs": 86400000 }, "queryType": 0, "resourceType": "microsoft.operationalinsights/workspaces", "visualization": "tiles", "tileSettings": {"showBorder": false,"titleContent": { "columnMatch": "Computer", "formatter": 1},"leftContent": { "columnMatch": "RemoteIPLongitude", "formatter": 12, "formatOptions": {"palette": "auto" }, "numberFormat": {"unit": 17,"options": { "maximumSignificantDigits": 3, "maximumFractionDigits": 2} }} }},"name": "Last HeartBeat by Computer" }, {"type": 3,"content": { "version": "KqlItem/1.0", "query": "Perf\\r\\n| where TimeGenerated > ago(5min)\\r\\n| where CounterName == \\"% Processor Time\\" and InstanceName == \\"_Total\\" \\r\\n| project TimeGenerated, Computer, ObjectName, CounterName, InstanceName, round(CounterValue, 2)\\r\\n| summarize arg_max(TimeGenerated, *) by Computer", "size": 4, "title": "%CPU utilization by Computer", "timeContext": {"durationMs": 86400000 }, "queryType": 0, "resourceType": "microsoft.operationalinsights/workspaces", "visualization": "tiles", "tileSettings": {"showBorder": false,"titleContent": { "columnMatch": "Computer", "formatter": 1},"leftContent": { "columnMatch": "CounterValue", "formatter": 12, "formatOptions": {"palette": "auto" }, "numberFormat": {"unit": 17,"options": { "maximumSignificantDigits": 3, "maximumFractionDigits": 2} }} }},"name": "%CPU utilization by Computer" }, {"type": 3,"content": { "version": "KqlItem/1.0", "query": "Perf\\r\\n| where TimeGenerated > ago(1h)\\r\\n| where (CounterName == \\"% Committed Bytes In Use\\" and ObjectName == \\"Memory\\") \\r\\n| project TimeGenerated, CounterName, CounterValue, Computer\\r\\n| summarize arg_max(TimeGenerated, *) by Computer\\r\\n", "size": 0, "title": "% Memory Usage by Computer", "timeContext": {"durationMs": 86400000 }, "queryType": 0, "resourceType": "microsoft.operationalinsights/workspaces", "visualization": "tiles", "tileSettings": {"showBorder": false,"titleContent": { "columnMatch": "Computer", "formatter": 1},"leftContent": { "columnMatch": "CounterValue", "formatter": 12, "formatOptions": {"palette": "auto" }, "numberFormat": {"unit": 17,"options": { "maximumSignificantDigits": 3, "maximumFractionDigits": 2} }} }},"name": "% Memory Usage by Computer" }] }'
    version: '1.0'
    sourceId: workbookSourceId
    category: workbookType
  }
}

resource workbookRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(azureplatformEngineer, MonitoringReader, workbookDisplayName)
  scope: workbookId_resource
  properties: {
    principalId: azureplatformEngineer
    roleDefinitionId: MonitoringReader
  }
  dependsOn: [
    workbookId_resource
  ]
}

output workbookResourceId string = workbookId_resource.id
output workbookName string = workbookId_resource.properties.displayName
