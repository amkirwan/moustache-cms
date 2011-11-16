class ApplicationController < ActionController::Base 
  protect_from_forgery 

  before_filter :current_site
  
  protected 

    def find_for_authentication(conditions)
      current_site if @current_site.nil?
      conditions[:site_id] = @current_site.id
      find_first_by_auth_conditions(conditions)
    end

    def current_admin_user
      #@current_admin_user ||= warden.authenticate(:scope => :#{mapping})
      super 
      current_site if @current_site.nil?
      if @current_admin_user.site.id != @current_site.id
        @current_admin_user = nil
      end
      @current_admin_user
    end

    def current_admin_user?(user)
      user == @current_admin_user
    end
  
    def current_site
      @current_site = Site.match_domain(request.host.downcase).first
      if @current_site.nil?
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
    end

    def current_ability
      @current_ability ||= Ability.new(current_admin_user)
    end
 
end
