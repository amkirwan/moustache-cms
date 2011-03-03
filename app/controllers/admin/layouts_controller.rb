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
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
end