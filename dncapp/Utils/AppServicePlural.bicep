param linuxFxVersionParam string = 'DOCKER|plural.azurecr.io/dncapp:remote-v1'
// 'DOCKER|jfvacr.azurecr.io/dncapp:remote-v1'
// 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest' 
param location string = resourceGroup().location // Location for all resources

targetScope = 'resourceGroup'

resource appServiceContainer 'Microsoft.Web/sites@2020-06-01' = {
  name: 'C2Aapp-Container'
  location: location
  identity: {
    type: 'SystemAssigned' 
  }  
  // kind: 'app,linux,container'
  properties: {
    // server farm id is service plan name
    serverFarmId: 'appsrvpln-v1'
    siteConfig: {
      linuxFxVersion: linuxFxVersionParam
    }
  }
}

// see docs for built in existing roles-- guid is name
resource AcrPullRole 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: appServiceContainer
  name: guid(appServiceContainer.id, AcrPullRole.id)
  properties: {
    roleDefinitionId: AcrPullRole.id
    principalId: appServiceContainer.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

