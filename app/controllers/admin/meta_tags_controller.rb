class Admin::MetaTagsController <AdminBaseController 

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
    if @base_class.meta_tags.push(@meta_tag)
      redirect_to [:edit, :admin, @base_class], :notice => "Successfully created meta tag #{@base_class.name}"
    else 
      render :new
    end
  end

  def update
    if @base_class.update_attributes(params[:meta_tag])
      redirect_to [:edit, :admin, @base_class], :notice => "Successfully updated the meta tag #{@base_class.name}" 
    else
      render :edit
    end
  end
  
  def destroy
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @base_class], :notice => "Successfully deleted the meta tag #{@base_class.name}" }
        format.js
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
