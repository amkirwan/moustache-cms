class CommentsController < ApplicationController

  def name
    @comment = Comment.new(article_id: params[:article_id])
  end

  def create  
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.request = request
    if @comment.save
      flash[:notice] = "Thanks for the comment."
    end
    redirect_to request.url
  end
end
