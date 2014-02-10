class WelcomeController < ApplicationController
  require 'securerandom'
  def index
    puts "<---------------DEBUG---ENTRY---BEGINS--------------->"
    puts "<-------restore---session---data--------------------->"
    @old_user = User.find(:all, :conditions => { :login => [cookies[:login]] })
    @cookie_login = cookies[:login]
    @cookie_token = cookies[:token]
    puts @cookie_login
    puts @cookie_token
    puts "<---------------DEBUG---ENTRY---ENDS----------------->"
    if !@user.blank?
      puts "<---------------DEBUG---ENTRY---BEGINS--------------->"
      puts "<-------user---found---in---storage------------------>"
      puts @old_user
      puts "<---------------DEBUG---ENTRY---ENDS----------------->"
      @user_token = Token.find(:all, :conditions => { :user_id => [@user[0].id] })
      if cookies[:token] == @user_token
        puts "<---------------DEBUG---ENTRY---BEGINS--------------->"
        puts "<-------session---token---matched---user---token----->"
        puts cookies[:token]
        puts "<---------------DEBUG---ENTRY---ENDS----------------->"
        redirect_to "login" and return
      end
    end
  end
  
  def login
    @user = User.find(:all, :conditions => { :login => [params[:login]] })
    @debug_msg = ""
    @token = ""
    if @user.blank?
      @debug_msg = "user login doesn't exist"
    end
    if !@debug_msg.blank?
      return @debug_msg
    end
    if @user[0].login == params[:login] && @user[0].password == params[:password]
      token = SecureRandom.hex
      Token.destroy_all(:user_id => @user[0].id)
      @new_token = Token.new
      @new_token.token = token
      @new_token.user_id = @user[0].id
      @new_token.save
      cookies.permanent[:login] = @user[0].login
      cookies.permanent[:token] = token  
      @session_login = @user[0].login 
      @session_token = token  
      @token = token
      puts "<---------------DEBUG---ENTRY---BEGINS--------------->"
      puts "<-------session---token---created-------------------->"
      puts cookies[:login]
      puts cookies[:token]
      puts @session_login
      puts @session_token
      puts "<---------------DEBUG---ENTRY---ENDS----------------->"
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