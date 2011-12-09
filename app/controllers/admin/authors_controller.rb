class Admin::AuthorsController < AdminBaseController

  load_and_authorize_resource 

  respond_to :html, :xml, :json

  # GET /admin/authors
  def index
    respond_with(:admin, @authors)
  end

  # GET /admin/authors/new
  def new
    respond_with(:admin, @authors)
  end

  # GET /admin/authors/1/edit
  def edit
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
end
