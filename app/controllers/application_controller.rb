class ApplicationController < ActionController::Base 
  protect_from_forgery 
                  
  protected 
  def identify_user   
    fake_login(params[:cas_user]) unless Rails.env == 'production'
    @user = User.where(:username => session[:cas_user])
  end 
  
  def fake_login(user)
    if Rails.env == "test"
      session[:cas_user] = user if session[:cas_user].nil?
    elsif Rails.env == 'development'
      session[:cas_user] = 'ak730' if session[:cas_user].nil?
      #session[:cas_user] = 'jb509' if session[:cas_user].nil?
      #session[:cas_user] = 'mac0' if session[:cas_user].nil?
      #session[:cas_user] = 'mas3' if session[:cas_user].nil?
    end
  end
end