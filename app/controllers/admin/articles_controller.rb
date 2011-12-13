class Admin::ArticlesController < AdminBaseController

  load_and_authorize_resource :article_collection
  load_and_authorize_resource :article, :through => :article_collection

  respond_to :html, :xml, :json

  #/admin/article_collections/1/articles
  def index
    @articles = @article_collection.articles.page(params[:page])
    respond_with(:admin, @article_collection, @articles)
  end

  


end
