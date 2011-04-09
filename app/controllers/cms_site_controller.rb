class CmsSiteController < ActionController::Base 
  
  before_filter :load_site
  before_filter :load_page, :only => :render_html
  
  def render_html
    #@page = Page.find_by_path(params[:url])
    render :nothing => true
  end
  
  private
  
  def load_site
    @current_site ||= Site.match_domain(request.host.downcase).first
    if @current_site.nil?
      render :file => "#{Rails.root}/public/404.html", :layout => 'layouts/application', :status => 404
    end
  end
  
  def load_page
    @page = Page.find_by_full_path(@site, "/#{params[:page_path]}")
    if @current_site.nil?
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => 'layouts/application', :status => 404
    end
  end
end