require 'ext/string'

class CmsSiteController < ApplicationController
  before_filter :request_set
  before_filter :load_page, :only => :render_html
  layout nil
  
  def render_html
    if !@page.nil? && (@page.published? || current_admin_user)
      document = MoustacheCms::Mustache::CmsPage.new(self).render
      document = Redcarpet::Render::SmartyPants.render(document) unless request.xhr?
      response.etag = document
      if request.fresh?(response)
        head :not_modified
      else
        respond_to do |format|
          format.js { render text: document }
          format.html { render text: document.clean_html, status: 200 }
          format.atom { render text: Nokogiri::XML(document, &:noblanks).to_xml(indent: 2) }
        end
      # end
    else
      render_404
    end
  end

  protected 

  def request_set
    @request = request
  end

  def request_permalink
    request.protocol + request.host + @article.permalink  
  end

  def load_page
    # render the page if the route is not an article
    if params[:articles].nil? && params[:year].nil?
      current_site_load_page
    else # handle article rendering
      current_site_load_article
    end
  end

  def article_by_permalink(extra_params=nil)
    # if the article is not routed within a collection then the permalink will be under the root page
    # if the article is routed within an article collection then the articles param will be set in the route
    permalink = "/#{params[:articles]}/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:title]}"
    permalink += "?#{extra_params}" unless extra_params.nil?
    permalink.squeeze!('/')  
    @current_site.article_by_permalink(permalink)
  end
  
  def render_404
    if @page = @current_site.page_by_full_path("/404")
      render :text => MoustacheCms::Mustache::CmsPage.new(self).render, :status => 404
    else 
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end

  # Returns the page for the site if it exists with the params[:page_path] given.
  # If the params[:preview] is set then it will look for the preview version of the page.
  # Otherwise it will attemtpt to load the page by the full path. If the page does not exist.
  # The 404 page will be rendered.
  def current_site_load_page
    if params[:preview] == 'true'
      @page = current_site.page_by_full_path("/#{params[:page_path]}?preview=#{params[:preview]}") 
      @page.destroy unless @page.nil?
    else
      @page = current_site.page_by_full_path("/#{params[:page_path]}")
    end
    return render_404 if @page.nil?
  end

  # Returns the article by permalink 
  # If the params[:preview] is set then it will look for the preview version of the article.
  # Otherwise load the article from the permalink.
  # Then find the page that the article should be rendered into from the params[:articles].
  # Render 404 if the page is nil or the page is the homepage and the article is does not exist.
  def current_site_load_article
    # assign the article by permalink
    if params[:preview] == 'true'
      @article = article_by_permalink("preview=#{params[:preview]}") 
      @article.destroy unless @article.nil?
    else
      @article = article_by_permalink
    end
    # find the page that the article will be rendered in.
    @page = params[:articles] ? @current_site.page_by_full_path("/#{params[:articles]}") : @current_site.homepage
      
    # Check if the page is the homepage and that the article is not nil. 
    # If it is render 404 because we don't want to render the home page when the
    # user is looking for a permalink. The root path would 
    return render_404 if @article.nil?
  end
end
