class Admin::UsersController < AdminBaseController    
 
  def index               
  end  
  
  def show
    render :edit
  end
  
  def new
  end                        
  
  def create   
    # set because attr_accessible   
    @user.puid = params[:user][:puid] if admin?
    @user.role = params[:user][:role] if admin?
    @user.site = @current_site
    if @user.save
      redirect_to admin_users_path, :notice => "Successfully created user profile for #{@user.full_name}" 
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update                    
    @user.role = params[:user][:role] if admin?
    if @user.update_attributes(params[:user]) 
      redirect_to admin_users_path, :notice => "Successfully updated user profile for #{@user.full_name}"
    else
      render :edit
    end
  end
  
  def destroy
    if @user.delete
      if current_user? @user
        reset_session
        redirect_to "http://#{@current_site.full_subdomain}"
      else
        redirect_to admin_users_path, :notice => "Successfully deleted user profile for #{@user.user_name}"
      end
    end
  end 
end
