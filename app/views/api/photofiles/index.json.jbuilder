json.photos @photos do |photo|
  json.created_at   photo.created_at
  json.updated_at   photo.updated_at
  json.id   photo.id
  json.url url_for(action: 'photoserve', controller: 'photofiles', only_path: false, protocol: 'http', id: photo.id)
end
