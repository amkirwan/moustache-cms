class CmsSiteController < ActionController::Base 
  
  before_filter :load_site
  before_filter :load_page, :only => :render_html
  layout nil
  
  def render_html
    render :text => Etherweb::CmsPage.new(self).render
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
  
  def mustache_params
    @page.page_parts.inject({}) {|hash,item| hash[item.name.to_sym] = item.content; hash }
  end
end