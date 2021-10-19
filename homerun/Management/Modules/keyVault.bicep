var tenantId = subscription().tenantId

param location string
param keyVaultNameD string
param keyVaultNameR string
param accessPolicies array
param environment string
param workspaceResourceId string

var objectIdAzurePlatform = '6352a0bc-73be-4c1d-8814-fd8c5cdba282'
var objectIdAzurePlatformTest = 'e802b0b2-68d2-416b-bf7a-1171d7d0d45a'
var objectIdAzurePlatformRO = '3b4f73ea-3329-4647-a9a8-10e2107204a9'

output deployTimeKeyVaultId string = keyvaultdeployment.id
output runTimeKeyVaultId string = keyvaultruntime.id

resource keyvaultdeployment 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultNameD
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    enablePurgeProtection: true
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: environment == 'prod' ? objectIdAzurePlatform : objectIdAzurePlatformTest
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
      {
        tenantId: tenantId
        objectId: objectIdAzurePlatformRO
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'      
    }
  }
}


resource keyvaultdeployment_Microsoft_Insights_LogAnalytics 'Microsoft.KeyVault/vaults/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${keyVaultNameD}/Microsoft.Insights/LogAnalytics'
  properties: {
    workspaceId: workspaceResourceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

resource keyvaultruntime 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultNameR
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    enablePurgeProtection: true
    accessPolicies: accessPolicies
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'      
    }
  }
}

resource keyvaultruntime_Microsoft_Insights_LogAnalytics 'Microsoft.KeyVault/vaults/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${keyVaultNameR}/Microsoft.Insights/LogAnalytics'
  properties: {
    workspaceId: workspaceResourceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
