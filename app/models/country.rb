class Country < ActiveRecord::Base
  has_many :locations
  validates :name , uniqueness: true


end
