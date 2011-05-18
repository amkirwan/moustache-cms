class Admin::MediaFilesController < AdminBaseController
  # GET /admin/media_files
  def index
  end

  # GET /admin/media_files/1
  def show
    render :edit
  end

  # GET /admin/media_files/new
  def new
  end

  # GET /admin/media_files/1/edit
  def edit
  end

  # POST /admin/media_files
  def create
    created_updated_by_for @media_file
    @media_file.attributes = { :site => @current_site }
    if @media_file.save
      flash[:notice] = "Successfully created the media file #{@media_file.name}"
      redirect_to admin_media_files_path
    else
      render :new
    end
  end

  # PUT /admin/media_files/1
  def update
    @media_file.updated_by = current_user
    if @media_file.update_attributes(params[:media_file])
      flash[:notice] = "Successfully updated the media file #{@media_file.name}"
      redirect_to admin_media_files_path
    else
      render :edit
    end
  end

  # DELETE /admin/media_files/1
  def destroy
    if @media_file.destroy
      flash[:notice] = "Successfully deleted the media file #{@media_file.name}"
      redirect_to admin_media_files_path
    end
  end
end
