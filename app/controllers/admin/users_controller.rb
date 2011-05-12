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
    @user.puid = params[:user][:puid]
    @user.role = params[:user][:role]
    @user.attributes = { :site => @current_site }
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
    @user.update_attributes(params[:user])
    @user.role = params[:user][:role] if admin?
    if @user.save
      flash[:notice] = "Successfully updated user account for #{@user.puid}"
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
      flash[:notice] = "Successfully deleted user account for #{@user.puid}"
      redirect_to admin_users_path
    end
  end 
end