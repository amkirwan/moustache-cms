class Admin::MediaFilesController < AdminBaseController
  # GET /admin/media_files
  # GET /admin/media_files.xml
  def index
  end

  # GET /admin/media_files/1
  # GET /admin/media_files/1.xml
  def show
    render :edit
  end

  # GET /admin/media_files/new
  # GET /admin/media_files/new.xml
  def new
  end

  # GET /admin/media_files/1/edit
  def edit
  end

  # POST /admin/media_files
  # POST /admin/media_files.xml
  def create
    created_updated_by_for @media_file
    if @media_file.save
      flash[:notice] = "Successfully created the media file #{@media_file.name}"
      redirect_to admin_media_files_path
    else
      render :new
    end
  end

  # PUT /admin/media_files/1
  # PUT /admin/media_files/1.xml
  def update
    @admin_media_file = Admin::MediaFile.find(params[:id])

    respond_to do |format|
      if @admin_media_file.update_attributes(params[:admin_media_file])
        format.html { redirect_to(@admin_media_file, :notice => 'Media file was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_media_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/media_files/1
  # DELETE /admin/media_files/1.xml
  def destroy
    @admin_media_file = Admin::MediaFile.find(params[:id])
    @admin_media_file.destroy

    respond_to do |format|
      format.html { redirect_to(admin_media_files_url) }
      format.xml  { head :ok }
    end
  end
end
