class AdminBaseController < ApplicationController
  protect_from_forgery   

  force_ssl if Rails.env == 'production'
    
  before_filter :authenticate_admin_user!
  after_filter :discard_flash_message

  check_authorization :unless => :devise_controller? 
  
  layout "admin/admin"
  
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}" 
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
  end
  
  protected 
      
    def admin?     
      current_admin_user.role?("admin")
    end

    def created_updated_by_for(obj)
      obj.created_by_id = current_admin_user.id
      obj.updated_by_id = current_admin_user.id
    end
  
    def assign_site
      hostname = HandlebarCms::Application.config.domain.downcase
    
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
    
    def current_site
      @current_site ||= Site.match_domain(request.host.downcase).first
      if @current_site.nil?
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
      @current_site
    end
    
    def logout
      reset_session
      redirect_to cms_html_path
    end

    def discard_flash_message
      if request.xhr? && response != :found
        flash.discard(:notice)
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

    def redirector_path(object)
     params[:commit] == "Save and Continue Editing" ? [:edit, :admin, object] : [:admin, object.class.name.pluralize.downcase.to_sym]
    end
    
    def redirector(path_continue, path_redirect, notice=nil)
      if params[:commit] == "Save and Continue Editing"
        redirect_to path_continue, :notice => notice
      else
        redirect_to path_redirect, :notice => notice
      end
    end

    def creator_updator_set_id(site_asset)
      site_asset.creator_id = current_admin_user.id
      site_asset.updator_id = current_admin_user.id
    end
end
