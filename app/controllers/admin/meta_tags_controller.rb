class Admin::MetaTagsController <AdminBaseController 

  load_and_authorize_resource :page
  load_resource :meta_tag, :through => :page

  def new
  end

  def edit
    #@page = Page.find(params[:page_id])
    #@meta_tag = @page.meta_tags.find(params[:id])
  end

  def create
    if @page.meta_tags.push(@meta_tag)
      redirect_to [:edit, :admin, @page], :notice => "Successfully created meta tag #{@meta_tag.name}"
    else 
      render :new
    end
  end
end
