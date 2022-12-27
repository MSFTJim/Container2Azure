// param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param verDay string = '1'
param verIteration string = '3'
param verCount string = '${verDay}-${verIteration}' 
param webAppName string = 'C2Aapp-${verCount}'

param linuxFxVersion string = 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest' // 
param location string = resourceGroup().location // Location for all resources
var appServicePlanName = toLower('AppSrvPln-${webAppName}')
var ASP_ID = resourceId('Microsoft.Web/serverfarms@2020-06-01','appsrvpln-c2aapp-1-1')

@description('This is the ASP_ID: ') 

resource appServiceFx 'Microsoft.Web/sites@2020-06-01' = {
  name: 'C2Aapp-NativeCode01'
  location: location
  // kind: 'app,linux'
  properties: {
    serverFarmId: 'appsrvpln-c2aapp-1-1'
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|7.0'
      appCommandLine: ''      
    }
  }
}
resource appServiceCntr 'Microsoft.Web/sites@2020-06-01' = {
  name: 'C2Aapp-Container01'
  location: location
  // kind: 'app,linux,container'
  properties: {
    serverFarmId: 'appsrvpln-c2aapp-1-1'
    siteConfig: {
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
      appCommandLine: ''      
    }
  }
}

