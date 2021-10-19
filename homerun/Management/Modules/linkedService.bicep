param logAnalyticsWorkSpaceName string
param automationAccountId string


resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name : logAnalyticsWorkSpaceName
  properties : {
    resourceId : automationAccountId
  }
}

