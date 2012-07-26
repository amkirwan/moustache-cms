class Admin::ThemeCollectionsController < AdminBaseController   
  include MoustacheCms::FriendlyFilename

  load_and_authorize_resource 

  respond_to :html, :xml, :json
  
  # GET /admin/asset_collections
  def index
    respond_with(:admin, @theme_collections)
  end
  
  # GET /admin/asset_collections/1
  def show
    @css_files = @theme_collection.theme_assets.css_files.asc(:name)
    @js_files = @theme_collection.theme_assets.js_files.asc(:name)
    @images = @theme_collection.theme_assets.images.asc(:name)
    @other_files = @theme_collection.theme_assets.other_files.asc(:name)
    respond_with(:admin, @theme_collection)
  end
  
  # GET /admin/asset_collections/new
  def new
    respond_with(:admin, @theme_collection)
  end
  
  #GET /admin/asset_collections/1/edit
  def edit
    respond_with @theme_collection
  end
  
  #POST /admin/asset_collections
  def create
    created_updated_by_for @theme_collection
    @theme_collection.site = current_site
    respond_with(:admin, @theme_collection) do |format|
      if @theme_collection.save
        format.html { redirect_to redirector_path(@theme_collection), :notice => "Successfully created the theme collection #{@theme_collection.name}" }
      end
    end
  end
  
  #PUT /admin/asset_collections/1
  def update
    @theme_collection.updated_by = @current_admin_user
    move_directory(@theme_collection.name, params[:theme_collection][:name])
    respond_with(:admin, @theme_collection) do |format| 
      if @theme_collection.update_attributes(params[:theme_collection]) 
        format.html { redirect_to redirector_path(@theme_collection), :notice => "Successfully updated the theme collection #{@theme_collection.name}" }
      end
    end
  end
  
  #DELETE /admin/asset_collections/1
  def destroy
    @theme_collection.destroy
    flash[:notice] = "Successfully deleted the asset collection #{@theme_collection.name}"
    respond_with(:admin, @theme_collection)
  end

  private

  def move_directory(old_name, new_name)
    old_dir = File.join(Rails.root, 'public', 'theme_assets', @theme_collection.site.id.to_s, old_name)
    new_dir = File.join(Rails.root, 'public', 'theme_assets', @theme_collection.site.id.to_s, friendly_filename(new_name))
    FileUtils.mv(old_dir, new_dir)
  end

end

