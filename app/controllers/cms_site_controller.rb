class CmsSiteController < ActionController::Base 
  
  before_filter :load_site
  before_filter :load_page, :only => :render_html
  
  def render_html
    #@page = Page.find_by_path(params[:url])
    render :nothing => true
  end
  
  private
  
  def load_site
    @site = Site.find_by_hostname(Etherweb::Application.config.hostname)
    if @site.nil?
      render :file => "#{Rails.root}/public/404.html", :layout => 'layouts/application', :status => 404
    end
  end
  
  def load_page
    @page = Page.find_by_full_path(@site, "/#{params[:page_path]}")
    if @site.nil?
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => 'layouts/application', :status => 404
    end
  end
end