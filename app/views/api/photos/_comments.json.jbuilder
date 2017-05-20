json.comments comments do |comment|
  json.id           comment.id
  json.comment      comment.comment
  json.created_at   time_ago_in_words(comment.created_at)
  json.user_avatar  @current_user.avatar
end
