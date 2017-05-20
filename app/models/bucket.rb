class Bucket < ApplicationRecord
  validates_uniqueness_of :user, :scope => :photo_id
  belongs_to :photo
end
