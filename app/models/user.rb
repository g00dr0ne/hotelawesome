class User < ActiveRecord::Base
  has_one :token
  has_many :rating
  validates :login, presence: true, length: { in: 6..20 }, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "only letters and/or numbers allowed" }, uniqueness: true
  validates :password, presence: true, length: { in: 6..20 }, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "only letters and/or numbers allowed" }
end
