class HotelsController < ApplicationController
  before_action :set_hotel, only: [:show, :edit, :update, :destroy]
  
  def top
    @hotels_top_arr = Hotel.all(:order => "rate DESC", :limit => 5)
    return @hotels_top_arr
  end
  
  def all 
    @hotels_all_arr = Hotel.all(:order => "rate DESC")
  end
  
  def see
    @hotel_for_rate = Hotel.find(params[:id])
  end
  
  def rate
    score = params[:rating].to_i
    hotel_id = params[:hotel_id]
    user_id = 1
    @rating = Rating.new do |r|
      r.score = score
      r.hotel_id = hotel_id
      r.user_id = user_id
    end
    Rating.where("user_id = " + user_id.to_s + " AND hotel_id = " + hotel_id.to_s).destroy_all
    if @rating.save
      Hotel.find(hotel_id).make_ratings
    end
  end

  # GET /hotels
  # GET /hotels.json
  def index
    @hotels = Hotel.all
  end

  # GET /hotels/1
  # GET /hotels/1.json
  def show
  end

  # GET /hotels/new
  def new
    @hotel = Hotel.new
  end

  # GET /hotels/1/edit
  def edit
  end

  # POST /hotels
  # POST /hotels.json
  def create
    @hotel = Hotel.new(hotel_params)
    respond_to do |format|
      if @hotel.save
        format.html { redirect_to @hotel, notice: 'Hotel was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hotel }
      else
        format.html { render action: 'new' }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel
      @hotel = Hotel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotel_params
      params.require(:hotel).permit(:title, :description, :address, :photoUrl, :price, :breakfast)
    end
    
    def rating_params
      all_params = Hash['rating', Hash['score', 0, 'hotel_id', 0, 'user_id', 0]]
      all_params.to_param.require(:rating)
    end
end
