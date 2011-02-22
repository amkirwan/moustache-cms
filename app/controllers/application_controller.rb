class ApplicationController < ActionController::Base 
  protect_from_forgery 
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access Denied!"
    redirect_to root_url
  end
                  
  def current_user    
    fake_login(params[:cas_user]) unless Rails.env == 'production'                    
    @current_user = User.where(:username => session[:cas_user]).first
  end  
  
  protected
  def admin?     
    @current_user.role?("admin")
  end
  
  private
  def fake_login(cas_user) 
    if Rails.env == "test"   
      session[:cas_user] = CASClient::Frameworks::Rails::Filter.fake_user if session[:cas_user].nil?
    elsif Rails.env == 'development'
      session[:cas_user] = 'ak730' if session[:cas_user].nil?
      #session[:cas_user] = 'jb509' if session[:cas_user].nil?
      #session[:cas_user] = 'mac0' if session[:cas_user].nil?
      #session[:cas_user] = 'mas3' if session[:cas_user].nil?
    end
  end
end