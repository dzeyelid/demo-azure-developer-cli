param location string = resourceGroup().location
param resourceToken string
param tags object = {}
param serviceTags object = {}

@allowed(['Premium_LRS', 'Premium_ZRS', 'Standard_GRS', 'Standard_GZRS', 'Standard_LRS', 'Standard_RAGRS', 'Standard_RAGZRS', 'Standard_ZRS'])
param storageAccountSkuName string = 'Standard_LRS'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'plan-${resourceToken}'
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  tags: tags
}

resource functionapp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'func-${resourceToken}'
  location: location
  kind: 'functionapp'
  tags: serviceTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    siteConfig: {
      http20Enabled: true
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'func-${resourceToken}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
      ]
    }
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'st${resourceToken}func'
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSkuName
  }
  tags: tags
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${resourceToken}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
  tags: tags
}

resource appInsightsDashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: 'dash-${resourceToken}'
  location: location
  properties: {
    lenses: []
  }
  tags: tags
}
