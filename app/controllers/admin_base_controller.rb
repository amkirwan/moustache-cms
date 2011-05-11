class AdminBaseController < ApplicationController
  protect_from_forgery
  
  before_filter :fake_login unless Rails.env == "production"
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :current_site
  #before_filter :assign_site
  
  load_and_authorize_resource 
  
  layout "admin/admin"
  
  rescue_from CanCan::AccessDenied do |exception|
    #flash[:error] = "Access Denied!"
    #redirect_to root_url
    render :file => "#{Rails.root}/public/403.html", :layout => false
  end
  
  def admin?     
    @current_user.role?("admin")
  end

  def created_updated_by_for(obj)
    obj.created_by = current_user
    obj.updated_by = current_user
  end
  
  protected
  
    def current_user                      
      @current_user = User.where(:puid => session[:cas_user]).first
    end  
  
    def assign_site
      hostname = Etherweb::Application.config.domain.downcase
    
      if hostname.nil?
        flash[:error] = "No hostname defined"
        return redirect_to(admin_pages_path)
      else
        if Site.count == 0
          @default_site = Site.create(:name => "Default Site", :hostname => hostname)
        elsif Site.count == 1
          @default_site = Site.where(:hostname => hostname).first
        end
      end
    
      unless @default_site
        flash[:error] = "No site defined for that hostname"
      end
    end
    
  private
    def fake_login
      if Rails.env == "test"   
        session[:cas_user] = CASClient::Frameworks::Rails::Filter.fake_user if session[:cas_user].nil?
      elsif Rails.env == 'development'
        CASClient::Frameworks::Rails::Filter.fake("ak730")
        #CASClient::Frameworks::Rails::Filter.fake("cds27")
        #session[:cas_user] = 'ak730' if session[:cas_user].nil?
        #session[:cas_user] = 'jb509' if session[:cas_user].nil?
        #session[:cas_user] = 'mac0' if session[:cas_user].nil?
        #session[:cas_user] = 'mas3' if session[:cas_user].nil?
      end
    end
    
    def current_site
      @current_site ||= Site.match_domain(request.host.downcase).first
      if @current_site.nil?
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
    end
end