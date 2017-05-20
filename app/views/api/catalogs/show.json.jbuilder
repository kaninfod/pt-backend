json.catalog do
  json.id                   @catalog.id
  json.name                 @catalog.name
  json.type                 @catalog.type
  json.verified             !!@catalog.access_token
  json.auth_url             @catalog.auth_url
  json.sync_from_catalog    @catalog.sync_from_catalog
  json.appkey               @catalog.appkey
  json.appsecret            @catalog.appsecret
  json.import_mode          @catalog.import_mode
end
