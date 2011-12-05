class Admin::ArticleCollectionsController < ApplicationController

  load_and_authorize_resource 

  respond_to :html, :xml, :json

  def index
    respond_with(:admin, @article_collections)
  end

end
