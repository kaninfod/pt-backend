json.buckets @bucket do |bucket|
  json.id           bucket.photo.id
  json.photo_url    bucket.photo.url('tm')
end
json.partial! 'photos/comments', comments: @photo.comments
