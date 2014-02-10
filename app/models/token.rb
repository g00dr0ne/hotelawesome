class Token < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true, uniqueness: true
  validates :token, presence: true, length: { minimum: 8 }
end
