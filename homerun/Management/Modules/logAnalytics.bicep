param logAnalyticsName string
param UpdateManagementName string
param logManagementActionGroupName string
param logManagementActionGroupShortName string

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

resource logAnalyticsName_LogicalDisk3 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk3'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Current Disk Queue Length'
  }
}

resource logAnalyticsName_LogicalDisk4 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk4'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Disk Reads/sec'
  }
}

resource logAnalyticsName_LogicalDisk5 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk5'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Disk Transfers/sec'
  }
}

resource logAnalyticsName_LogicalDisk6 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk6'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Disk Writes/sec'
  }
}

resource logAnalyticsName_LogicalDisk7 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk7'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Free Megabytes'
  }
}

resource logAnalyticsName_LogicalDisk8 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/LogicalDisk8'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 300
    counterName: '% Free Space'
  }
}

resource logAnalyticsName_Memory1 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Memory1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Memory'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Available MBytes'
  }
}

resource logAnalyticsName_Memory2 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Memory2'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Memory'
    instanceName: '*'
    intervalSeconds: 300
    counterName: '% Committed Bytes In Use'
  }
}

resource logAnalyticsName_Memory3 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Memory3'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Memory'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Free System Page Table Entries'
  }
}

resource logAnalyticsName_Memory4 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Memory4'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Memory'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Pages/sec'
  }
}

resource logAnalyticsName_Network1 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Network1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Network Adapter'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Bytes Received/sec'
  }
}

resource logAnalyticsName_Network2 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Network2'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Network Adapter'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Bytes Sent/sec'
  }
}

resource logAnalyticsName_Network3 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Network3'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Network Adapter'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Bytes Total/sec'
  }
}

resource logAnalyticsName_Processor1 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Processor1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Processor'
    instanceName: '_Total'
    intervalSeconds: 300
    counterName: '% Processor Time'
  }
}

resource logAnalyticsName_Processor2 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Processor2'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Processor'
    instanceName: '_Total'
    intervalSeconds: 300
    counterName: '% Interrupt Time'
  }
}

resource logAnalyticsName_Processor3 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Processor3'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Processor'
    instanceName: '_Total'
    intervalSeconds: 300
    counterName: '% DPC Time'
  }
}

resource logAnalyticsName_Processor4 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/Processor4'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Processor'
    instanceName: '*'
    intervalSeconds: 300
    counterName: '% Processor Time'
  }
}

resource logAnalyticsName_System1 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/System1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'System'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Processor Queue Length'
  }
}

resource logAnalyticsName_System2 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/System2'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'System'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'System Up Time'
  }
}

resource logAnalyticsName_TerminalService1 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/TerminalService1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'terminal service gateway'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'current connections'
  }
}

resource logAnalyticsName_WindowsTime1 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/WindowsTime1'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Windows Time Service'
    instanceName: '*'
    intervalSeconds: 300
    counterName: 'Computed Time Offset'
  }
}

resource logAnalyticsName_PagingFile01 'microsoft.operationalinsights/workspaces/datasources@2015-11-01-preview' = {
  name: '${LogAnalytics.name}/PagingFile01'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Paging File'
    instanceName: '*'
    intervalSeconds: 300
    counterName: '% Usage'
  }
}

resource UpdateManagement 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: UpdateManagementName
  location : location
  plan: {
      name:UpdateManagementName
      promotionCode: ''
      product: 'OMSGallery/Updates'
      publisher: 'Microsoft'
  }
  properties: {
      workspaceResourceId: LogAnalytics.id
      containedResources: [
          concat(LogAnalytics.id, concat('/views/', UpdateManagementName))
      ]
  }
}

module metricAlertsActionGroup './actionGroup.bicep' = {
  name:logManagementActionGroupName
  params: {
    actionGroupName:logManagementActionGroupName
    actionGroupShortName:logManagementActionGroupShortName
  }
}

output LogAnalyticsName string = LogAnalytics.name
output LogAnalyticsId string = LogAnalytics.id
