targetScope = 'subscription'

@description('Specify the name of the offer from the Managed Service Provider')
param mspOfferName string

@description('Name of the Managed Service Provider offering')
param mspOfferDescription string

@description('Specify the tenant id of the Managed Service Provider')
param managedByTenantId string

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
param authorizations array

var mspRegistrationName_var = guid(mspOfferName)
var mspAssignmentName_var = guid(mspOfferName)

resource mspRegistrationName 'Microsoft.ManagedServices/registrationDefinitions@2019-06-01' = {
  name: mspRegistrationName_var
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

resource mspAssignmentName 'Microsoft.ManagedServices/registrationAssignments@2019-06-01' = {
  name: mspAssignmentName_var
  properties: {
    registrationDefinitionId: mspRegistrationName.id
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations