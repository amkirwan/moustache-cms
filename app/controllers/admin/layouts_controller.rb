class Admin::LayoutsController < AdminBaseController  

  def index 
  end
  
  def new
  end
  
  def create
    created_updated_by_for @layout
    @layout.site = @current_site
    if @layout.save
      flash[:notice] = "Successfully created the layout #{@layout.name}"
      redirect_to admin_layouts_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update    
    @layout.updated_by = @current_user
    if @layout.update_attributes(params[:layout]) 
      flash[:notice] = "Successfully updated the layout #{@layout.name}"
      redirect_to admin_layouts_path
    else
      render :edit
    end
  end
  
  def destroy
    if @layout.destroy
      flash[:notice] = "Successfully deleted the layout #{@layout.name}"
      redirect_to admin_layouts_path
    end
  end
end