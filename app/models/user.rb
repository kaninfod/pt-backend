class User < ApplicationRecord
  has_secure_password
  acts_as_voter

end
