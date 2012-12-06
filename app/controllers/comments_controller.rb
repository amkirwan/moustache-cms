class CommentsController < ApplicationController

  respond_to :html

  def name
    @comment = Comment.new(article_id: params[:article_id])
  end

  def create  
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.request = request
    if @comment.save
      flash[:notice] = "Thanks for the comment."
      redirect_to request.protocol + request.host + @article.permalink
    else
      render :text => 'hello, world error'
    end
  end
end
