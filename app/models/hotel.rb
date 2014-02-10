class Hotel < ActiveRecord::Base
  has_many :rating
  validates :title, presence: true, length: { in: 2..30 }, uniqueness: true, format: { with: /([a-zA-Z0-9*] ?)*[a-zA-Z0-9]\z/ }
  validates :description, presence: true, length: { maximum: 240 }, format: { with: /[\w\s!;'":,\?&.\(\)]*/ }
  validates :price, presence: true, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000 }
  validates :address, presence: true, length: { maximum: 120 }, format: { with: /[\w\s:,\?&.\\\/\*\(\)]*/ }
  validates :photoUrl, presence: true
end
