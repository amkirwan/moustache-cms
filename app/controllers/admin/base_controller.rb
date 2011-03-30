class Admin::BaseController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :etherweb_site
  
  load_and_authorize_resource 
  
  layout "admin/admin"
  
  protected
  
  def etherweb_site
    hostname = Etherweb::Application.config.hostname.downcase
    
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
end