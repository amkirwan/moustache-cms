class Admin::UsersController < Admin::BaseController    
 
  def index               
  end  
  
  def show
    render :edit
  end
  
  def new
  end                        
  
  def create   
    @user.puid = params[:user][:puid] if admin?
    @user.role = params[:user][:role] if admin?
    if @user.save
      flash[:notice] = "Successfully created user account for #{@user.username}" 
      redirect_to admin_users_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update                    
    @user.attributes = params[:user]
    @user.role = params[:user][:role] if admin?
    if @user.save
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
    if @user.delete
      flash[:notice] = "Successfully deleted user account for #{@user.username}"
      redirect_to admin_users_path
    end
  end 
end