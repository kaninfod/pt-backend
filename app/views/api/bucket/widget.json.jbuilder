json.bucket @bucket do |bucket|
  json.id           bucket.photo.id
  json.photo_url    bucket.photo.url('tm')
end
json.comments   []
json.tags   []
json.albums @albums do |album|
  json.id album.id
  json.name album.name
end

json.current_user do
  json.id         @current_user.id
  json.username   @current_user.name
  json.avatar     @current_user.avatar
  json.email      @current_user.email
end

json.taglist @taglist do |tag|
  json.id tag.id
  json.name tag.name
  json.count tag.taggings_count
end
