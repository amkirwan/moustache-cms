class Admin::SnippetsController < AdminBaseController   
  
  def index               
  end  
  
  def show
    render :edit
  end
  
  def new
  end
  
  def create   
    # set because attr_accessible   
    @snippet.site = @current_site
    if @snippet.save
      redirect_to [:admin, :snippets], :notice => "Successfully created the snippet #{@snippet.name}" 
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update                    
    @user.role = params[:user][:role] if admin?
    if @user.update_attributes(params[:user]) 
      redirect_to admin_users_path, :notice => "Successfully updated user account for #{@user.puid}"
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
        redirect_to admin_users_path, :notice => "Successfully deleted user account for #{@user.puid}"
      end
    end
  end
end