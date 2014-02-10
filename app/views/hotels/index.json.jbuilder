json.array!(@hotels) do |hotel|
  json.extract! hotel, :id, :title, :description, :address, :photoUrl, :price, :breakfast
  json.url hotel_url(hotel, format: :json)
end
