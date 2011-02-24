class Admin::UsersController < ApplicationController    
  before_filter CASClient::Frameworks::Rails::Filter
  authorize_resource 
  
  layout "admin/admin"  
  def index             
    @users = User.accessible_by(current_ability)  
  end  
  
  def show
    @user = User.find(params[:id])
    render :edit
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
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
  end
  
  def update                    
    params[:user].delete(:role) unless admin?
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user account for #{@user.username}"
      if admin?
        redirect_to admin_users_path
      else
        render :edit
      end 
    else
      render :edit
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