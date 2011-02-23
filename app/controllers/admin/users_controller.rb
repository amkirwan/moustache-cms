class Admin::UsersController < ApplicationController    
  before_filter CASClient::Frameworks::Rails::Filter
  load_and_authorize_resource 
  skip_load_resource
  
  layout "admin/admin"  
  def index             
    @users = User.all  
  end  
  
  def show
    @users = User.all
    render :action => index
  end
  
  def new
    @user = User.new
  end                         
  
  def create   
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user account for #{@user.username}" 
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update                      
    params[:user].delete(:role) unless admin?
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user account for #{@user.username}"
      redirect_to admin_users_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted user account for #{@user.username}"
      redirect_to admin_users_path
    end
  end 
  
end