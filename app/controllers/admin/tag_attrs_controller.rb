class Admin::TagAttrsController < AdminBaseController 

  load_and_authorize_resource :theme_asset
  load_resource :tag_attr, :through => :theme_asset

  respond_to :html, :xml, :json
  respond_to :js, :only => [:new, :destroy]

  def new
    respond_with(:admin, @theme_asset, @tag_attr)
  end

  def edit
    respond_with(:admin, @theme_asset, @tag_attr)
  end

  def create
    respond_with(:admin, @theme_asset, @tag_attr) do |format|
      if @theme_asset.tag_attrs.push(@tag_attr)
        format.html { redirect_to [:edit, :admin, @theme_asset], :notice => "Successfully created the tag attribute #{@tag_attr.name}" }
      end
    end
  end

  def update
    respond_with(:admin, @theme_asset, @tag_attr) do |format|
      if @tag_attr.update_attributes(params[:tag_attr])
        format.html { redirect_to [:edit, :admin, @theme_asset], :notice => "Successfully updated the tag attribute #{@tag_attr.name}" }
      end
    end
  end


  def destroy
    @tag_attr.destroy
    respond_with(:admin, @theme_asset, @tag_attr) do |format|
      format.html { redirect_to [:edit, :admin, @theme_asset], :notice => "Successfully deleted the tag attribute #{@tag_attr.name}" }
    end
  end 

end
