targetScope = 'resourceGroup'

param roleDefinitionId string
param managedIdentityResourceId string 


var roleAssignmentScope = resourceGroup().id
var roleAssignmentName =  guid(managedIdentityResourceId, roleDefinitionId, roleAssignmentScope)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleAssignmentName
  properties: {
    scope: roleAssignmentScope
    principalId: reference(managedIdentityResourceId,'2018-11-30','Full').properties.principalId
    roleDefinitionId: roleDefinitionId
  }
}