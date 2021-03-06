class Hotel < ActiveRecord::Base
  
  has_many :rating
  
  validates :title, presence: true, length: { in: 2..30 }, uniqueness: true, format: { with: /([a-zA-Z0-9*] ?)*[a-zA-Z0-9]\z/ }
  validates :description, presence: true, length: { maximum: 240 }, format: { with: /[\w\s!;'":,\?&.\(\)]*/ }
  validates :price, presence: true, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000 }
  validates :address, presence: true, length: { maximum: 120 }, format: { with: /[\w\s:,\?&.\\\/\*\(\)]*/ }
  validates :photoUrl, presence: true
  
  def set_rate (in_rate)
    self.rate = in_rate
    self.save
  end
  
  def make_ratings
    all_ratings = Rating.all 
    all_hotels = Hotel.all
    loop_size = all_hotels.size
    loop_size -= 1
    if loop_size > -1
      hotel_ratings = Array.new(loop_size * 3)
      for i in 0..loop_size
        hotel_ratings[(i*3)] = all_hotels[i].id
        hotel_ratings[(i*3)+1] = 0
        hotel_ratings[(i*3)+2] = 0                  
      end 
      loop_size_rating = all_ratings.size
      loop_size_rating -= 1
      for i in 0..loop_size_rating
        for j in 0..loop_size
          matched = false
          if hotel_ratings[(j*3)] == all_ratings[i].hotel_id
            hotel_ratings[(j*3)+1] += all_ratings[i].score
            hotel_ratings[(j*3)+2] += 1   
            matched = true           
          end
          break if matched 
        end              
      end
      for i in 0..loop_size
        if hotel_ratings[(i*3)+2] > 0
          hotel_ratings[(i*3)+1] = hotel_ratings[(i*3)+1] / hotel_ratings[(i*3)+2]
        end
      end
      for i in 0..loop_size
        @hotel = Hotel.find(hotel_ratings[i*3])
        @hotel.set_rate(hotel_ratings[(i*3)+1])
      end         
    end
  end
  
end
