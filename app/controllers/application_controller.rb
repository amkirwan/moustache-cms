class ApplicationController < ActionController::Base 
  protect_from_forgery 

  before_filter :current_site
  
  protected 

    def find_for_authentication(conditions)
      current_site if @current_site.nil?
      conditions[:site_id] = @current_site.id
      find_first_by_auth_conditions(conditions)
    end

    def current_admin_user?(user)
      user == @current_admin_user
    end
  
    def current_site
      @current_site ||= Site.match_domain(request.host.downcase).first
      if @current_site.nil?
        render :file => "#{Rails.root}/public/404", :layout => false, :status => 404
      end
      @current_site
    end

    def current_ability
      @current_ability ||= Ability.new(current_admin_user)
    end

end
