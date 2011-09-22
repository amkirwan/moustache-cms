class Admin::MetaTagsController <AdminBaseController 

  load_and_authorize_resource :page
  load_resource :meta_tag, :through => :page

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create
    if @page.meta_tags.push(@meta_tag)
      redirect_to [:edit, :admin, @page], :notice => "Successfully created meta tag #{@meta_tag.name}"
    else 
      render :new
    end
  end

  def update
    if @meta_tag.update_attributes(params[:meta_tag])
      redirect_to [:edit, :admin, @page], :notice => "Successfully updated the meta tag #{@meta_tag.name}" 
    else
      render :edit
    end
  end
  
  def destroy
    if @meta_tag.destroy
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @page], :notice => "Successfully deleted the meta tag #{@meta_tag.name}" }
        format.js
      end
    end
  end
end
