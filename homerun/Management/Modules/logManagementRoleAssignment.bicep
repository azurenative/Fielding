param roleAssignmentScope string
param managedIdentityResourceId string 

param monitorContributorRoleDefinitionId string
param readerAndDataAccessRoleDefinitionId string

var monitorContributorRoleAssignmentName = guid(managedIdentityResourceId, monitorContributorRoleDefinitionId, roleAssignmentScope)
var readerAndDataAccessRoleAssignmentName = guid(managedIdentityResourceId, readerAndDataAccessRoleDefinitionId, roleAssignmentScope)

resource monitorContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: monitorContributorRoleAssignmentName
  properties: {
    scope: roleAssignmentScope
    principalId: reference(managedIdentityResourceId,'2018-11-30','Full').properties.principalId
    roleDefinitionId: monitorContributorRoleDefinitionId
  }
}

resource readerAndDataAccessRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: readerAndDataAccessRoleAssignmentName
  properties: {
    scope: roleAssignmentScope
    principalId: reference(managedIdentityResourceId,'2018-11-30','Full').properties.principalId
    roleDefinitionId: readerAndDataAccessRoleDefinitionId
  }
}