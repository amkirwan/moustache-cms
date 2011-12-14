class Admin::MetaTagsController < AdminBaseController 

  load_resource :site
  load_resource :page
  load_resource :article
  load_and_authorize_resource :meta_tag, :through => [:site, :page, :article]
  before_filter :assign_base_class

  respond_to :html, :except => :show
  respond_to :xml, :json
  respond_to :js, :only => [:new, :destroy]

  def new
    respond_with(:admin, @meta_tag)
  end

  def edit
    respond_with(:admin, @meta_tag)
  end

  def create
    respond_with(:admin, @meta_tag) do |format|
      if @meta_tag.save
        format.html { redirect_to [:edit, :admin, @base_class], :notice => "Successfully created the meta tag #{@meta_tag.name}" }
      end
    end
  end

  def update
    respond_with(:admin, @meta_tag) do |format|
      if @meta_tag.update_attributes(params[:meta_tag])
        format.html { redirect_to [:edit, :admin, @base_class], :notice => "Successfully updated the meta tag #{@meta_tag.name}" }
      end
    end
  end
  
  def destroy
    respond_with(:admin, @meta_tag) do |format|
      if @meta_tag.destroy
        format.html { redirect_to [:edit, :admin, @base_class], :notice => "Successfully deleted the meta tag #{@meta_tag.name}" }
      end
    end
  end

  private
    def assign_base_class
      if params[:page_id]
        @base_class = @page
      elsif params[:article_id]
        @base_class = @article
      else
        @base_class = @site
      end
    end
    
end
