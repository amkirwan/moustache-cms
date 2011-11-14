class ApplicationController < ActionController::Base 
  protect_from_forgery 

  before_filter :authenticate_admin_user!
  before_filter :request_set
  before_filter :load_site
  
  protected 

    def current_admin_user?(user)
      user == @current_admin_user
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

    def current_ability
      @current_ability ||= Ability.new(current_admin_user)
    end
 
end
