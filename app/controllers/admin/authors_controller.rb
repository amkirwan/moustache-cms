class Admin::AuthorsController < AdminBaseController

  load_and_authorize_resource 

  respond_to :html, :xml, :json

  # GET /admin/authors
  def index
    respond_with(:admin, @authors)
  end

  # GET /admin/authors/new
  def new
    respond_with(:admin, @author)
  end

  # GET /admin/authors/1/edit
  def edit
    respond_with(:admin, @author)
  end

  # POST /admin/authors
  def create
    created_updated_by_for @author
    @author.site = @current_site
    if @author.save
      flash[:notice] = "Successfully created the author #{@author.full_name}"
    end
    respond_with(:admin, @author, :location => [:admin, :authors])
  end

  def update
    @author.updated_by = @current_admin_user
    if @author.update_attributes(params[:author])
      flash[:notice] = "Successfully updated the author #{@author.full_name}"
    end
    respond_with(:admin, @author, :location => [:admin, :authors])
  end

  def destroy
    if @author.destroy
      flash[:notice] = "Successfully deleted the user #{@author.full_name}"
    end
    respond_with(:admin, @author, :location => [:admin, :authors])
  end
end
