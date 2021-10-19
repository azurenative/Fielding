param location string = resourceGroup().location
param automationAccountName string

resource automationAccountUpdateManagement 'Microsoft.Automation/automationAccounts@2015-10-31' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

output automationAccountUpdateManagementId string = automationAccountUpdateManagement.id
