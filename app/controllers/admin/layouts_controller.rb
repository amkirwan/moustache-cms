class Admin::LayoutsController < AdminBaseController  

  def index 
  end
  
  def new
  end
  
  def create
    created_updated_by_for @layout
    @layout.site = @current_site
    if @layout.save
      redirect_to [:admin, :layouts], :notice => "Successfully created the layout #{@layout.name}"  
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update    
    @layout.updated_by = @current_user
    if @layout.update_attributes(params[:layout]) 
      redirect_to [:admin, :layouts], :notice => "Successfully updated the layout #{@layout.name}"
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