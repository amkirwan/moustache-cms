class SiteController < ActionController::Base 
  
  def render_page
    #@page = Page.find_by_path(params[:url])
    render :inline => "#{params[:cms_path]}"
    #render :nothing => true
  end
  
  private
    def find_page(url)
    
    end
end