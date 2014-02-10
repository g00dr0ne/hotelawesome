class WelcomeController < ApplicationController
  require 'securerandom'
  def index
  end
  
  def login
    @user = User.find(:all, :conditions => { :login => [params[:login]] })
    @debug_msg = ""
    if @user.blank?
      @debug_msg = "user login doesn't exist"
      return @debug_msg
    end
    if @user[0].login == params[:login] && @user[0].password == params[:password]
      @token = SecureRandom.hex
      Token.destroy_all(:user_id => @user[0].id)
      @new_token = Token.new
      @new_token.token = @token
      @new_token.user_id = @user[0].id
      @new_token.save
    else
      @debug_msg = "password mismatch"
      return @debug_msg
    end
  end
  
  def login_form
  end
  
  def logout
  end
end