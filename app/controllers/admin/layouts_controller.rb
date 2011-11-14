class Admin::LayoutsController < AdminBaseController  

  load_and_authorize_resource 

  respond_to :html, :except => :show
  respond_to :xml, :json

  def index 
    respond_with(:admin, @layouts)
  end

  def show
    respond_with(:admin, @layout)
  end
  
  def new
    respond_with(:admin, @layout)
  end
  
  def create
    created_updated_by_for @layout
    @layout.site = @current_site
    respond_with(:admin, @layout) do |format|
      if @layout.save
        format.html { redirect_to redirector_path(@layout), :notice => "Successfully created the layout #{@layout.name}" }
      end
    end
  end
  
  def edit
    respond_with(:admin, @layout)
  end
  
  def update    
    @layout.updated_by = @current_admin_user
    respond_with(:admin, @layout) do |format|
      if @layout.update_attributes(params[:layout]) 
        format.html { redirect_to redirector_path(@layout), :notice => "Successfully updated the layout #{@layout.name}" }
      end
    end
  end
  
  def destroy
    @layout.destroy
    flash[:notice] = "Successfully deleted the layout #{@layout.name}"
    respond_with(:admin, @layout)
  end
end
