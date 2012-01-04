class Admin::ThemeAssetsController < AdminBaseController
  include HandlebarCms::AssetCache  
  
  load_and_authorize_resource :theme_collection
  load_and_authorize_resource :theme_asset, :through => :theme_collection  

  respond_to :html, :xml, :json

  # GET /admin/theme_assets 
  def index
    respond_with(:admin, @theme_collection, @theme_assets) do |format|
      format.html { redirect_to [:admin, @theme_collection] }
    end

  end  

  # GET /admin/theme_assets/new 
  def new
    @theme_asset.tag_attrs.build
    respond_with(:admin, @theme_collection, @theme_asset) 
  end
    
  # GET /admin/theme_assets/1/edit
  def show
    respond_with(:admin, @theme_collection, @theme_asset) do |format|
      format.html { render :edit }
    end
  end
  
  # POST /admin/theme_assets
  def create
    creator_updator_set_id @theme_asset    
    try_theme_asset_cache 
    respond_with(:admin, @theme_collection, @theme_asset) do |format| 
      if @theme_asset.save
        format.html { redirect_to [:admin, @theme_collection, :theme_assets], :notice => "Successfully created the theme asset #{@theme_asset.name}"  }
      end
    end
  end    
  
  # GET /admin/theme_asset/1/edit
  def edit
    respond_with(:admin, @theme_collection, @theme_asset)
  end
   
  # PUT /admin/theme_assets/1 
  def update   
    @theme_asset.updator_id = current_admin_user.id
    respond_with(:admin, @theme_collection, @theme_asset) do |format|
      if @theme_asset.update_attributes(params[:theme_asset]) && @theme_asset.update_file_content(params[:theme_asset_file_content])
        format.html { redirect_to [:admin, @theme_collection, :theme_assets], :notice => "Successfully updated the theme asset #{@theme_asset.name}" }
      end
    end
  end                                                            
  
  def destroy
    @theme_asset.destroy
    flash[:notice] = "Successfully deleted the theme asset #{@theme_asset.name}"
    respond_with(:admin, @theme_collection, @theme_asset)
  end   
  
  private
    def try_theme_asset_cache 
      if !params[:theme_asset][:asset_cache].empty? && params[:theme_asset][:asset].nil?
        set_from_cache(:cache_name => params[:theme_asset][:asset_cache], :asset => @theme_asset)
      end
    end
end
