class Admin::MetaTagsController <AdminBaseController 

  load_and_authorize_resource :page
  load_and_authorize_resource :meta_tag, :through => :page

  def new
    render :nothing => true
  end
end
