param logAnalyticsName string

var location = resourceGroup().location

resource LogAnalytics 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource logAnalyticsName_LogicalDisk1 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Avg Disk sec/Read'
  }
}

resource logAnalyticsName_LogicalDisk2 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk2'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Avg Disk sec/Write'
  }
}

output LogAnalyticsName string = LogAnalytics.name
