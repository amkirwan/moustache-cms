class Admin::MediaFilesController < AdminBaseController
  # GET /admin/media_files
  # GET /admin/media_files.xml
  def index
  end

  # GET /admin/media_files/1
  # GET /admin/media_files/1.xml
  def show
    @admin_media_file = Admin::MediaFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_media_file }
    end
  end

  # GET /admin/media_files/new
  # GET /admin/media_files/new.xml
  def new
    @admin_media_file = Admin::MediaFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_media_file }
    end
  end

  # GET /admin/media_files/1/edit
  def edit
    @admin_media_file = Admin::MediaFile.find(params[:id])
  end

  # POST /admin/media_files
  # POST /admin/media_files.xml
  def create
    @admin_media_file = Admin::MediaFile.new(params[:admin_media_file])

    respond_to do |format|
      if @admin_media_file.save
        format.html { redirect_to(@admin_media_file, :notice => 'Media file was successfully created.') }
        format.xml  { render :xml => @admin_media_file, :status => :created, :location => @admin_media_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_media_file.errors, :status => :unprocessable_entity }
      end
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
