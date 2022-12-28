// param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param verDay string = '1'
param verIteration string = '3'
param verCount string = '${verDay}-${verIteration}' 
param webAppName string = 'C2Aapp-${verCount}'
//
//param AcrPullRole string = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

param linuxFxVersion string = 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest' // 

param location string = resourceGroup().location // Location for all resources



// resource appServiceFx 'Microsoft.Web/sites@2020-06-01' = {
//   name: 'C2Aapp-NativeCode01'
//   location: location
//   // kind: 'app,linux'
//   properties: {
//     serverFarmId: 'appsrvpln-c2aapp-1-1'
//     siteConfig: {
//       linuxFxVersion: 'DOTNETCORE|7.0'
//       appCommandLine: ''      
//     }
//   }
// }
resource appServiceContainer 'Microsoft.Web/sites@2020-06-01' = {
  name: 'C2Aapp-ContainerD2I1'
  location: location
  identity: {
    type: 'SystemAssigned' 
  }  
  // kind: 'app,linux,container'
  properties: {
    serverFarmId: 'appsrvpln-c2aapp-1-1'
    siteConfig: {
      linuxFxVersion: ''
      appCommandLine: ''      
    }
  }
}


@description('This is the built-in Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
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

