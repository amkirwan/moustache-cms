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
    created_updated_by_for @author
    @author.site = @current_site
    if @author.save
      flash[:notice] = "Successfully created the author #{@author.full_name}"
    end
    respond_with(:admin, @author, :location => [:admin, :authors])
  end

  # PUT /admin/authors/1
  def update
    @author.updated_by = @current_admin_user
    if @author.update_attributes(params[:author])
      flash[:notice] = "Successfully updated the author #{@author.full_name}"
    end
    respond_with(:admin, @author, :location => [:admin, :authors])
  end

  # DELETE /admin/authors/1
  def destroy
    if @author.destroy
      flash[:notice] = "Successfully deleted the user #{@author.full_name}"
    end
    respond_with(:admin, @author, :location => [:admin, :authors])
  end

  private

    def change_name_md5
      @author.name = params[:author][:name]
      if @author.name_changed?
        old_name_split = @author.filename_md5_was.split('-')
        hash_ext = old_name_split.pop
        hash = hash_ext.split('.').shift
        @author.filename_md5 = "#{@author.name.split('.').first}-#{hash}.#{@author.asset.file.extension}"
        generate_paths
      end
    end

    def generate_paths
      @author.file_path_md5 = File.join(Rails.root, 'public', @author.asset.store_dir, '/', @author.filename_md5)
      @author.url_md5 = "/#{@author.asset.store_dir}/#{@author.filename_md5}"
      @author.file_path_md5_old = @author.file_path_md5_was if @author.file_path_md5_changed?
    end

end
