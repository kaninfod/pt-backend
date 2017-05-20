module BucketActions
  extend ActiveSupport::Concern

  def add_comment_helper(photo_id, comment_string)

    photo = Photo.find(photo_id)
    comment = photo.comments.create
    comment.comment = comment_string
    comment.user_id = current_user.id
    comment.save

    photo.objective_list.add comment_string.scan(/(^\#\w+|(?<=\s)\#\w+)/).join(',')
    photo.tag_list.add comment_string.scan(/(^\@\w+|(?<=\s)\@\w+)/).join(',')
    photo.save
    return comment
  end

  def rotate_helper(photo_array, degrees)
    Photo.find(photo_array).each do |photo|
      photo.rotate(degrees)
    end
  end

end
