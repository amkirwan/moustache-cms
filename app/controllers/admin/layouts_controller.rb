class Admin::LayoutsController < AdminBaseController  

  def index 
  end
  
  def new
  end
  
  def create
    created_updated_by_for @layout if admin?
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
    @layout.update_attributes(params[:layout])
    @layout.updated_by = current_user if admin?
    if @layout.save
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