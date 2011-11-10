class ApplicationController < ActionController::Base 
  protect_from_forgery 

  before_filter :request_set
  before_filter :load_site
  
  protected 

    def current_user
      current_site if @current_site.nil?
      @current_user ||= User.where(:puid => session[:cas_user], :site_id => @current_site.id).first
    end  
      
    def current_user?(user)
      user == @current_user
    end

    def request_set
      @request = request
    end
  
    def load_site
      @current_site = Site.match_domain(request.host.downcase).first
      if @current_site.nil?
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
    end
 
end
