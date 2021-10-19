param storageAccountName string

var location = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true    
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
  kind: 'StorageV2'
}

output resourceId string = storageAccount.id
