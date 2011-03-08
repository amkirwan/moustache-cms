class Admin::PagesController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter
  load_and_authorize_resource 
  
  layout "admin/admin"
  
  def index
  end
  
  def new
  end
  
  def create
    @page.created_by = current_user
    @page.updated_by = current_user
    if @page.save
      flash[:notice] = "Successfully created page #{@page.title}"
      redirect_to admin_pages_path
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
