class ApplicationController < ActionController::Base 
  protect_from_forgery 
  
  protected 
    def current_user
      current_site if @current_site.nil?
      @current_user ||= User.where(:puid => session[:cas_user], :site_id => @current_site.id).first
    end  
    
    def current_user?(user)
      user == @current_user
    end
end