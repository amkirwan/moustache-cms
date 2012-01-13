class CmsSiteController < ApplicationController
  
  before_filter :request_set
  before_filter :load_page, :only => :render_html
  layout nil
  
  def render_html
    if !@page.nil? && (@page.published? || current_admin_user)
      mustache_response = HandlebarCms::Mustache::CmsPage.new(self).render
      response.etag = mustache_response
      if request.fresh?(response.etag)
        head :not_modified
      else
        render :text => mustache_response, :status => 200
      end
    else
      render_404
    end
  end
  
  private

    def request_set
      @request = request
    end
  
    def load_page
      @page = @current_site.page_by_full_path("/#{params[:page_path]}")
      if @page.nil?
        render_404
      end
    end
    
    def render_404
      if @page = @current_site.page_by_full_path("404")
        render :text => HandlebarCms::Mustache::CmsPage.new(self).render, :status => 404
      else 
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
    end

end
