param updateManagementGroupName string
param actionGroupLocation string
param actionGroupName string
param actionGroupShortName string
param alertName string
param automationAccountName string
param automationAccountID string

module actionGroup 'actionGroup.bicep' = {
  name: actionGroupName
  params: {
    actionGroupLocation: actionGroupLocation
    actionGroupName: actionGroupName
    actionGroupShortName: actionGroupShortName
  }
}

resource metricAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: alertName
  location: actionGroupLocation
  tags: {}
  properties: {
    description: 'Alert on failed update'
    severity: 3
    enabled: true
    scopes: [
      automationAccountID
    ]
    evaluationFrequency: 'PT30M'
    windowSize: 'PT6H'
    targetResourceType: 'microsoft.automation/automationaccounts'
    criteria: {
      'allOf': [
        {
          threshold: 1
          name: 'Metric1'
          metricNamespace: 'Microsoft.Automation/automationAccounts'
          metricName: 'TotalUpdateDeploymentRuns'
          dimensions: [
            {
              name: 'SoftwareUpdateConfigurationName'
              operator: 'Include'
              values: [
                'deploymentupdateservice-Linux-all'
                'deploymentupdateservice-Windows-all'
              ]
            }
            {
              name: 'Status'
              operator: 'Include'
              values: [
                'Failed'
              ]
            }
          ]
          operator: 'GreaterThan'
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    autoMitigate: false
    actions: [
      {
        actionGroupId: actionGroup.outputs.resourceID
        webHookProperties: {}
      }
    ]
  }
}
