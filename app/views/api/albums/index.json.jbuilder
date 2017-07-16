json.albums @albums do |album|
  json.id             album.id
  json.name           album.name
  json.count          album.album_photos.count

  if album.album_photos.count != 0

    json.url          album.album_photos.first.url('md')
  else

    json.url          Photo.null_photo
  end
end
