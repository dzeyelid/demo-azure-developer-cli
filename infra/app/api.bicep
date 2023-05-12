param location string = resourceGroup().location
param resourceToken string
param tags object = {}
param serviceName string = 'api'

module functionapp '../core/functionapp.bicep' = {
  name: 'functionapp'
  params: {
    resourceToken: resourceToken
    location: location
    tags: tags
    serviceTags: union(tags, { 'azd-service-name': serviceName })
  }
}
