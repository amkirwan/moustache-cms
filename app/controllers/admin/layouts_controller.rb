class Admin::LayoutsController < ApplicationController    
  before_filter CASClient::Frameworks::Rails::Filter
  load_and_authorize_resource 
  
  layout "admin/admin"
  def index 
  end
  
  def new
  end
  
  def create
    @layout.created_by_id = current_user.id if admin?
    @layout.updated_by_id = current_user.id if admin?
    if @layout.save
      flash[:notice] = "Successfully created layout #{@layout.name}"
      redirect_to admin_layouts_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    @layout.attributes = params[:layout]
    @layout.updated_by_id = current_user.id if admin?
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