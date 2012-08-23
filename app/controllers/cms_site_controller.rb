class CmsSiteController < ApplicationController
  
  before_filter :request_set
  before_filter :load_page, :only => :render_html
  layout nil
  
  def render_html
    if !@page.nil? && (@page.published? || current_admin_user)
      mustache_response = MoustacheCms::Mustache::CmsPage.new(self).render
      response.etag = mustache_response
      if request.fresh?(response)
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
      # render the page if the route is not an article
      if params[:articles].nil? && params[:year].nil?
        @page = @current_site.page_by_full_path("/#{params[:page_path]}")
        render_404 if @page.nil?
      else 
        # find the page first to render the article into
        @page = params[:articles] ? @current_site.page_by_full_path("/#{params[:articles]}") : @current_site.page_by_full_path('/')
        
        # if the article is not within a collection then the permalink will be under the root page
        # if the article is under an article collection then the articles param will be set in the route
        @article = @current_site.article_by_permalink("/#{params[:articles]}/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:title]}".squeeze)

        # Check if the page is the home page and that the article is not nil. 
        # If it is render 404 because we don't want to render the home page when the
        # user is looking for a permalink. The root path would 
        render_404 if @page.home_page? && @article.nil?
        render_404 if @page.nil?
      end
    end
    
    def render_404
      if @page = @current_site.page_by_full_path("404")
        render :text => MoustacheCms::Mustache::CmsPage.new(self).render, :status => 404
      else 
        render :file => "#{Rails.root}/public/404.html", :status => 404
      end
    end

end
