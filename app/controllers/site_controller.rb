class SiteController < ActionController::Base 
  
  def dynamic_page
    @page = Page.find_by_path(params[:url])
    render :nothing => true
  end
  
  private
    def find_page(url)
    
    end
end