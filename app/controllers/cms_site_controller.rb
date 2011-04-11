class CmsSiteController < ActionController::Base 
  
  before_filter :load_site
  before_filter :load_page, :only => :render_html
  
  def render_html
    #@page = Page.find_by_path(params[:url])
    #render :text => "#{@page.page_parts[0].content}"
    page = Liquid::Template.parse(@page.page_parts[0].content)
    page.render
  end
  
  private
  
  def load_site
    @current_site ||= Site.match_domain(request.host.downcase).first
    if @current_site.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end
  
  def load_page
    @page = @current_site.pages.where(:full_path => "/#{params[:page_path]}").first
    if @page.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end
end