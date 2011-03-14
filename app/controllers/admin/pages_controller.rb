class Admin::PagesController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter
  load_and_authorize_resource 
  
  layout "admin/admin"
  
  def index
  end
  
  def new
    @page.build_current_state
  end
  
  def create
    @page.filter = Filter.find(params[:page][:filter])
    @page.layout_id = params[:page][:layout_id]
    @page.current_state = CurrentState.find(params[:page][:current_state_attributes][:id])
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
