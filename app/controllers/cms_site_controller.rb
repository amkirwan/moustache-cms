class CmsSiteController < ActionController::Base 
  
  before_filter :load_site
  before_filter :load_page, :only => :render_html
  layout nil
  
  def render_html
    render :text => Etherweb::CmsPage.new(self).render, :status => 200
  end
  
  private
  
    def load_site
      @current_site = Site.match_domain(request.host.downcase).first
      if @current_site.nil?
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
    end
  
    def load_page
      @page = @current_site.page_by_full_path("/#{params[:page_path]}")
      if @page.nil?
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
    end
end