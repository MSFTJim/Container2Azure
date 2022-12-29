// param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name


param sku string = 'S1' // The SKU of App Service Plan

param location string = resourceGroup().location // Location for all resources
var appServicePlanName = toLower('AppSrvPln-V1')

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

