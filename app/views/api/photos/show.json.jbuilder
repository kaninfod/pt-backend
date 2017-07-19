json.photo do
  json.id           @photo.id
  json.model        @photo.model
  json.make         @photo.make
  json.date_taken   @photo.date_taken_formatted
  json.url_tm       @photo.url('tm')
  json.url_md       @photo.url('md')
  json.url_lg       @photo.url('lg')
  json.url_org      @photo.url('org')
  json.tags         @photo.tags
  json.like         @current_user.voted_for? @photo
  json.partial! 'api/photos/comments', comments: @photo.comments
  json.location do
    json.address @photo.location.address
    json.country @photo.location.country
    json.map_url @photo.location.map_url
  end
end

json.albums @albums do |album|
  json.id album.id
  json.name album.name
end
json.current_user @current_user

json.taglist @taglist do |tag|
  json.id tag.id
  json.name tag.name
  json.count tag.taggings_count
end
