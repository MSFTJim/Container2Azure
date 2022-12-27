// param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param verDay string = '1'
param verIteration string = '1'
param verCount string = '${verDay}-${verIteration}' 
param webAppName string = 'C2Aapp-${verCount}'
param sku string = 'S1' // The SKU of App Service Plan
param linuxFxVersion string = 'DOTNETCORE|7.0' // The runtime stack of web app
param location string = resourceGroup().location // Location for all resources
var appServicePlanName = toLower('AppSrvPln-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

