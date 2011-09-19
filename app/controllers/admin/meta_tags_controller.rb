class Admin::MetaTagsController <AdminBaseController 

  load_and_authorize_resource :page
  load_and_authorize_resource :meta_tag, :through => :page

  def new
  end

  def create
    if @page.meta_tags.create(@meta_tag)
      redirect_to [:edit, :admin, @page], :notice => "Successfully created meta tag #{@meta_tag.name}"
    end
  end
end
