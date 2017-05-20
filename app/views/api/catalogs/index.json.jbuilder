json.catalogs @catalogs do |catalog|
  json.id           catalog.id
  json.name         catalog.name
  json.type         catalog.type
  if catalog.photos.count > 0
    json.url          catalog.photos.first.url('md')
  else
    json.url          Photo.null_photo
  end
end
