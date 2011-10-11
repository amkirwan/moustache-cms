class Admin::TagAttrsController < AdminBaseController 

  load_and_authorize_resource :theme_asset
  load_resource :tag_attr, :through => :theme_asset

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create
    if @theme_asset.tag_attrs.push(@tag_attr)
      redirect_to [:edit, :admin, @theme_asset], :notice => "Successfully created the tag attribute #{@tag_attr.name}"
    else
     render :new
    end 
  end

  def update
    if @tag_attr.update_attributes(params[:tag_attr])
      redirect_to [:edit, :admin, @theme_asset], :notice => "Successfully updated the tag attribute #{@tag_attr.name}"
    else
      render :edit
    end
  end


  def destroy
    if @tag_attr.destroy
      respond_to do |format|
        format.js 
      end
    end
  end 

end
