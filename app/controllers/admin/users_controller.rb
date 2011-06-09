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
      flash[:notice] = "Successfully created user account for #{@user.puid}" 
      redirect_to admin_users_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update                    
    @user.role = params[:user][:role] if admin?
    if @user.update_attributes(params[:user]) 
      flash[:notice] = "Successfully updated user account for #{@user.puid}"
      redirect_to admin_users_path
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
        flash[:notice] = "Successfully deleted user account for #{@user.puid}"
        redirect_to admin_users_path
      end
    end
  end 
end