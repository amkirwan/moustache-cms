class Admin::LayoutsController < AdminBaseController  

  load_and_authorize_resource 

  respond_to :html, :except => :show
  respond_to :xml, :json

  def index 
    @layouts = @layouts.where(:site_id => current_admin_user.site_id).order_by(:name => 'ASC')
    respond_with(:admin, @layouts)
  end

  def show
    respond_with(:admin, @layout)
  end
  
  def new
    respond_with(:admin, @layout)
  end

  def edit
    respond_with(:admin, @layout)
  end
  
  def create
    assign_protected_attributes @layout
    respond_with(:admin, @layout) do |format|
      if @layout.save
        format.html { redirect_to redirector_path(@layout), :notice => "Successfully created the layout #{@layout.name}" }
      end
    end
  end
  
  def update    
    assign_updated_by @layout
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
