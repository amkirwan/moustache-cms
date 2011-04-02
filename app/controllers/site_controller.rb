class SiteController < ActionController::Base 
  
  before_filter :load_site
  before_filter :load_page, :only => :render_page
  
  def render_html
    #@page = Page.find_by_path(params[:url])
    render :nothing => true
  end
  
  private
  
  def load_site
    @site = Site.load_by_hostname(Etherweb::Application.config.hostname)
  rescue Mongoid::Errors::DocumentNotFound
    render :text => "Site Not Found",
  end
  
  def load_page
    @page = Page.load_by_full_path(@site, "/#{params[:page_path]}")
  rescue Mongoid::Errors::DocumentNotFound
    if @page = Page.published.load_by_full_path(@site, "/#{params[:page_path]}")
      render_html(404)
    else
      render :text => "Page Not Found", :status => 404
    end
  end
end