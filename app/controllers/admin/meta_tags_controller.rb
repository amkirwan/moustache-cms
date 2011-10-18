class Admin::MetaTagsController < AdminBaseController 

  load_resource :site
  load_resource :page
  load_and_authorize_resource :meta_tag, :through => [:site, :page]
  before_filter :assign_base_class

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create
    if @meta_tag.save
      redirect_to [:edit, :admin, @base_class], :notice => "Successfully created the meta tag #{@meta_tag.name}"
    else 
      render :new
    end
  end

  def update
    if @meta_tag.update_attributes(params[:meta_tag])
      redirect_to [:edit, :admin, @base_class], :notice => "Successfully updated the meta tag #{@meta_tag.name}" 
    else
      render :edit
    end
  end
  
  def destroy
    if @meta_tag.destroy
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @base_class], :notice => "Successfully deleted the meta tag #{@meta_tag.name}" }
        format.js
      end
    end
  end

  private
    def assign_base_class
      if params[:page_id]
        @base_class = @page
      else
        @base_class = @site
      end
    end
    
end
