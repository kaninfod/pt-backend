json.bucket @output[:response][:bucket] do | bucket|
  json.id           bucket.photo.id
  json.photo_url           bucket.photo.url('tm')
end
json.photo_id @output[:response][:photo_id]
