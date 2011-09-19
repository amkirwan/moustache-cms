class Admin::MetaDataController <AdminBaseController 

  load_and_authorize_resource :page

  def new
    Hash.new
  end
end
