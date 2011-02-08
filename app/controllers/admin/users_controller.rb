class Admin::UsersController < ApplicationController  
  
  ####### uncomment to deploy #################
  before_filter CASClient::Frameworks::Rails::Filter
  ##############################################   
  before_filter :identify_user  
  
  def identify_user   
    fake_login(params[:cas_user]) unless Rails.env == 'production'
    @user = User.where(:username => session[:cas_user])
  end 
  
  def fake_login(user)
    if Rails.env == "test"
      session[:cas_user] = user if session[:cas_user].nil?
    elsif Rails.env == 'development'
      session[:cas_user] = 'ak730' if session[:cas_user].nil?
      #session[:cas_user] = 'jb509' if session[:cas_user].nil?
      #session[:cas_user] = 'mac0' if session[:cas_user].nil?
      #session[:cas_user] = 'mas3' if session[:cas_user].nil?
    end
  end 
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end                         
  
  def show
    @user = User.new(session[:user_id])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created User." 
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated User."
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to root_path
    end
  end 
  
end