param actionGroupLocation string = 'global'
param actionGroupName string
param actionGroupShortName string

resource actionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  name: actionGroupName
  location: actionGroupLocation
  tags: {}
  properties: {
    groupShortName: actionGroupShortName
    enabled: true
    emailReceivers: [
      {
        name: 'alertMail'
        emailAddress: 'alerts@azurenative.com'
        useCommonAlertSchema: false
      }
    ]
  }
}

output resourceID string = actionGroup.id
