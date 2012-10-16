class Admin::AuthorsController < AdminBaseController

  load_and_authorize_resource 

  respond_to :html, :xml, :json

  # GET /admin/authors
  def index
    @authors = @authors.where(:site_id => current_admin_user.site_id)
    respond_with(:admin, @authors)
  end

  # GET /admin/authors/new
  def new
    respond_with(:admin, @author)
  end

  # GET /admin/authors/1
  def show
    respond_with(:admin, @author)
  end

  # GET /admin/authors/1/edit
  def edit
    respond_with(:admin, @author)
  end

  # POST /admin/authors
  def create
    save_and_assign_notice(@author, "Successfully created the author #{@author.full_name}")
    respond_with(:admin, @author, :location => [:admin, :authors])
  end
  
  # PUT /admin/authors/1
  def update
    assign_updated_by @author
    update_and_assign_notice(@author, params[:author], "Successfully updated the author", :full_name)
    respond_with(:admin, @author, :location => [:admin, :authors])
  end

  # DELETE /admin/authors/1
  def destroy
    if @author.destroy
      flash[:notice] = "Successfully deleted the user #{@author.full_name}"
    end
    respond_with(:admin, @author, :location => [:admin, :authors])
  end

end
