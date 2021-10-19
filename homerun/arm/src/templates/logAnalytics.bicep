param logAnalyticsName string

var location = resourceGroup().location

resource logAnalyticsName_resource 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource logAnalyticsName_LogicalDisk1 'Microsoft.OperationalInsights/workspaces/dataSources@2015-11-01-preview' = {
  parent: logAnalyticsName_resource
  name: 'LogicalDisk1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Avg Disk sec/Read'
  }
}

resource logAnalyticsName_LogicalDisk2 'Microsoft.OperationalInsights/workspaces/dataSources@2015-11-01-preview' = {
  parent: logAnalyticsName_resource
  name: 'LogicalDisk2'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Avg Disk sec/Write'
  }
}

output LogAnalyticsName string = logAnalyticsName