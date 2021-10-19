param logAnalyticsId string
param location string
param sharedDashboardName string
param workbookResourceId string
param workbookDisplayName string
param logManagementResourceGroupName string
param logAnalyticsName string

var workBookviewName = concat('Updates(', logAnalyticsName, ')')
var solutionId = resourceId(logManagementResourceGroupName, 'Microsoft.OperationsManagement/solutions/', workBookviewName)
var solutionIdView = concat(logAnalyticsId, '/views/', workBookviewName)

resource sharedDashboardName_resource 'Microsoft.Portal/dashboards@2015-08-01-preview' = {
  name: sharedDashboardName
  location: location
  properties: {
    lenses: {
      '0': {
        order: 0
        parts: {
          '0': {
            position: {
              x: 0
              y: 0
              colSpan: 6
              rowSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: logAnalyticsId
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  value: null
                  isOptional: true
                }
                {
                  name: 'ResourceIds'
                  value: [
                    logAnalyticsId
                  ]
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: workbookResourceId
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'microsoft.operationalinsights/workspaces'
                  isOptional: true
                }
                {
                  name: 'PinName'
                  value: workbookDisplayName
                  isOptional: true
                }
                {
                  name: 'StepSettings'
                  value: '{"version":"KqlItem/1.0","query":"Perf\\r\\n| where TimeGenerated > ago(5min)\\r\\n| where ObjectName == \\"Logical Disk\\" or ObjectName == \\"LogicalDisk\\" and CounterName contains \\"%\\" and InstanceName != \\"_Total\\" and InstanceName != \\"HarddiskVolume1\\" \\r\\n| project TimeGenerated, Computer, ObjectName, CounterName, InstanceName, CounterValue \\r\\n| summarize arg_max(TimeGenerated, *) by Computer \\r\\n| top 10 by CounterValue desc","size":4,"title":"Free disk space % by Computer","timeContext":{"durationMs":86400000},"queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","visualization":"tiles","tileSettings":{"showBorder":false,"titleContent":{"columnMatch":"Computer","formatter":1},"leftContent":{"columnMatch":"CounterValue","formatter":12,"formatOptions":{"palette":"auto"},"numberFormat":{"unit":17,"options":{"maximumSignificantDigits":3,"maximumFractionDigits":2}}}}}'
                  isOptional: true
                }
                {
                  name: 'ParameterValues'
                  value: {}
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: 'westeurope'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart'
            }
          }
          '1': {
            position: {
              x: 6
              y: 0
              colSpan: 4
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: solutionIdView
                }
                {
                  name: 'solutionId'
                  value: solutionId
                  isOptional: true
                }
                {
                  name: 'timeInterval'
                  isOptional: true
                }
                {
                  name: 'timeRange'
                  binding: 'timeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/ViewTileIFramePart'
            }
          }
          '2': {
            position: {
              x: 12
              y: 0
              colSpan: 3
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'chartType'
                  isOptional: true
                }
                {
                  name: 'isShared'
                  isOptional: true
                }
                {
                  name: 'queryId'
                  isOptional: true
                }
                {
                  name: 'formatResults'
                  isOptional: true
                }
                {
                  name: 'partTitle'
                  value: 'Failed backup jobs last 24hr'
                  isOptional: true
                }
                {
                  name: 'query'
                  value: '// GetFailedBackupJobs\n// Click the "Run query" command above to execute the query and see results.\nRecoveryServicesResources\n| where type == "microsoft.recoveryservices/vaults/backupjobs"\n| where properties.backupManagementType == "AzureIaasVM"\n| where properties.startTime > ago(1d)\n| where properties.status == "Failed"\n| extend vaultId = tolower(replace("\\\\/backupJobs.*","",id))\n| extend SubText = "Jobs"\n| summarize Failed=count()'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/ArgQuerySingleValueTile'
            }
          }
          '3': {
            position: {
              x: 12
              y: 2
              colSpan: 3
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'chartType'
                  isOptional: true
                }
                {
                  name: 'isShared'
                  isOptional: true
                }
                {
                  name: 'queryId'
                  isOptional: true
                }
                {
                  name: 'formatResults'
                  isOptional: true
                }
                {
                  name: 'partTitle'
                  value: 'InProgress backup jobs last 24hr'
                  isOptional: true
                }
                {
                  name: 'query'
                  value: '// GetInProgressBackupJobs\n// Click the "Run query" command above to execute the query and see results.\nRecoveryServicesResources\n| where type == "microsoft.recoveryservices/vaults/backupjobs"\n| where properties.backupManagementType == "AzureIaasVM"\n| where properties.startTime > ago(1d)\n| where properties.status == "InProgress"\n| extend vaultId = tolower(replace("\\\\/backupJobs.*","",id))\n| extend SubText = "Jobs"\n| summarize InProgress=count()'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/ArgQuerySingleValueTile'
            }
          }
          '4': {
            position: {
              x: 0
              y: 8
              colSpan: 6
              rowSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: logAnalyticsId
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  value: null
                  isOptional: true
                }
                {
                  name: 'ResourceIds'
                  value: [
                    logAnalyticsId
                  ]
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: workbookResourceId
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'microsoft.operationalinsights/workspaces'
                  isOptional: true
                }
                {
                  name: 'PinName'
                  value: workbookDisplayName
                  isOptional: true
                }
                {
                  name: 'StepSettings'
                  value: '{"version":"KqlItem/1.0","query":"Perf\\r\\n| where TimeGenerated > ago(5min)\\r\\n| where CounterName == \\"% Processor Time\\" and InstanceName == \\"_Total\\" \\r\\n| project TimeGenerated, Computer, ObjectName, CounterName, InstanceName, round(CounterValue, 2)\\r\\n| summarize arg_max(TimeGenerated, *) by Computer","size":4,"title":"%CPU utilization by Computer","timeContext":{"durationMs":86400000},"queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","visualization":"tiles","tileSettings":{"showBorder":false,"titleContent":{"columnMatch":"Computer","formatter":1},"leftContent":{"columnMatch":"CounterValue","formatter":12,"formatOptions":{"palette":"auto"},"numberFormat":{"unit":17,"options":{"maximumSignificantDigits":3,"maximumFractionDigits":2}}}}}'
                  isOptional: true
                }
                {
                  name: 'ParameterValues'
                  value: {}
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: 'westeurope'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart'
            }
          }
          '5': {
            position: {
              x: 12
              y: 4
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/Microsoft_Azure_DataProtection/PartType/BackupCenterPart'
              deepLink: '#blade/Microsoft_Azure_DataProtection/BackupCenterMenuBlade/overview'
            }
          }
          '6': {
            position: {
              x: 0
              y: 4
              colSpan: 6
              rowSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: logAnalyticsId
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  value: null
                  isOptional: true
                }
                {
                  name: 'ResourceIds'
                  value: [
                    logAnalyticsId
                  ]
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: workbookResourceId
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'microsoft.operationalinsights/workspaces'
                  isOptional: true
                }
                {
                  name: 'PinName'
                  value: workbookDisplayName
                  isOptional: true
                }
                {
                  name: 'StepSettings'
                  value: '{"version":"KqlItem/1.0","query":"Heartbeat\\r\\n| summarize arg_max(TimeGenerated,*) by Computer","size":4,"title":"Last HeartBeat by Computer","timeContext":{"durationMs":86400000},"queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","visualization":"tiles","tileSettings":{"showBorder":false,"titleContent":{"columnMatch":"Computer","formatter":1},"leftContent":{"columnMatch":"RemoteIPLongitude","formatter":12,"formatOptions":{"palette":"auto"},"numberFormat":{"unit":17,"options":{"maximumSignificantDigits":3,"maximumFractionDigits":2}}}}}'
                  isOptional: true
                }
                {
                  name: 'ParameterValues'
                  value: {}
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: 'westeurope'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart'
            }
          }
          '7': {
            position: {
              x: 0
              y: 12
              colSpan: 6
              rowSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: logAnalyticsId
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  value: null
                  isOptional: true
                }
                {
                  name: 'ResourceIds'
                  value: [
                    logAnalyticsId
                  ]
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: workbookResourceId
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'microsoft.operationalinsights/workspaces'
                  isOptional: true
                }
                {
                  name: 'PinName'
                  value: workbookDisplayName
                  isOptional: true
                }
                {
                  name: 'StepSettings'
                  value: '{"version":"KqlItem/1.0","query":"Perf\\r\\n| where TimeGenerated > ago(1h)\\r\\n| where (CounterName == \\"% Processor Time\\" and InstanceName == \\"_Total\\") or CounterName == \\"% Used Memory\\"\\r\\n| project TimeGenerated, CounterName, CounterValue, Computer\\r\\n| summarize arg_max(TimeGenerated, *) by Computer\\r\\n","size":0,"title":"% Memory Usage by Computer","timeContext":{"durationMs":86400000},"queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","visualization":"tiles","tileSettings":{"showBorder":false,"titleContent":{"columnMatch":"Computer","formatter":1},"leftContent":{"columnMatch":"CounterValue","formatter":12,"formatOptions":{"palette":"auto"},"numberFormat":{"unit":17,"options":{"maximumSignificantDigits":3,"maximumFractionDigits":2}}}}}'
                  isOptional: true
                }
                {
                  name: 'ParameterValues'
                  value: {}
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: 'westeurope'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart'
            }
          }
        }
      }
    }
  }
}
