class HotelsController < ApplicationController
  before_action :set_hotel, only: [:show, :edit, :update, :destroy]
  
  def top
    @hotels_top_arr = Hotel.find(:all, :order => "rate DESC", :limit => 5)
    return @hotels_top_arr
  end
  
  def all 
    @hotels_all_arr = Hotel.find(:all, :order => "rate DESC")
  end
  
  def details
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
    user_id_from_rating = user_id
    hotel_id_from_rating = hotel_id
    Rating.where("user_id = " + user_id.to_s + " AND hotel_id = " + hotel_id.to_s).destroy_all
    if @rating.save
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
          hotel = Hotel.find(hotel_ratings[i*3])
          hotel.rate = hotel_ratings[(i*3)+1]
          hotel.save
        end         
      end
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

  # PATCH/PUT /hotels/1
  # PATCH/PUT /hotels/1.json
  def update
    respond_to do |format|
      if @hotel.update(hotel_params)
        format.html { redirect_to @hotel, notice: 'Hotel was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotels/1
  # DELETE /hotels/1.json
  def destroy
    @hotel.destroy
    respond_to do |format|
      format.html { redirect_to hotels_url }
      format.json { head :no_content }
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
