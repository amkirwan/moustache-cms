class Admin::LayoutsController < AdminBaseController  

  def index 
  end
  
  def new
  end
  
  def create
    created_updated_by_for @layout
    @layout.site = @current_site
    if @layout.save
      redirector [:edit, :admin, @layout], [:admin, :layouts], "Successfully created the layout #{@layout.name}"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update    
    @layout.updated_by = @current_user
    if @layout.update_attributes(params[:layout]) 
      redirector [:edit, :admin, @layout], [:admin, :layouts], "Successfully updated the layout #{@layout.name}"
    else
      render :edit
    end
  end
  
  def destroy
    if @layout.destroy
      redirect_to [:admin, :layouts], :notice => "Successfully deleted the layout #{@layout.name}"
    end
  end
end