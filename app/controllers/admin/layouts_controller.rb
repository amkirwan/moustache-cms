class Admin::LayoutsController < ApplicationController    
  before_filter CASClient::Frameworks::Rails::Filter
  load_and_authorize_resource 
  
  layout "admin/admin"
  def index 
  end
  
  def show
  end
  
  def new
  end
  
  def create
    @layout.created_by = current_user if admin?
    @layout.updated_by = current_user if admin?
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
  end
  
  def destroy
  end
  
end