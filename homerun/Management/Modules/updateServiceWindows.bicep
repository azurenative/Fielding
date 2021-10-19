targetScope = 'resourceGroup'
param automationAccountName string
param duration string
param frequency string
param locationFilter array
param osType string
param rebootSetting string
param scheduleName string
param scopeFilter array
param startTime string
param weekDays string


resource automationAccountName_ScheduleName 'Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01' ={
  name: '${automationAccountName}/${scheduleName}'
  properties: {
    updateConfiguration: {
      operatingSystem: osType
      duration: duration
      windows: {        
        includedUpdateClassifications: 'Critical, Definition, Security'
        rebootSetting: rebootSetting
      }
      targets: {
        azureQueries: [
          {
            scope: scopeFilter
            tagSettings: {
              tags: {}
              filterOperator: 'All'
            }
            locations: locationFilter
          }
        ]
      }
    }
    scheduleInfo: {
      frequency: frequency
      timeZone: 'Europe/Amsterdam'
      interval: 1
      startTime: startTime
      advancedSchedule: {
        weekDays: [
          weekDays
        ]
      }
    }
  }
}
