class CommentsController < CmsSiteController

  before_filter :load_page, only: :create

  def create  
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.request = request
    flash[:notice] = "Thanks for the comment." if @comment.save
    document = MoustacheCms::Mustache::CmsPage.new(self).render
    render text: document.clean_html
  end

end
