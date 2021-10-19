param managedIdentityName string

output managedIdentityId string = managedIdentityResource.id

resource managedIdentityResource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: resourceGroup().location
}





