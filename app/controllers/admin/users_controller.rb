class Admin::UsersController < AdminBaseController    
 
  load_and_authorize_resource 

  def index               
  end  
  
  def show
    render :edit
  end
  
  def new
  end                        
  
  def create   
    # set because attr_accessible   
    admin_only
    @user.site = @current_site
    if @user.save
      redirect_to [:admin, :users], :notice => "Successfully created user profile for #{@user.full_name}" 
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update                    
    admin_only
    if @user.update_attributes(params[:user]) 
      redirect_to [:admin, :users], :notice => "Successfully updated user profile for #{@user.full_name}"
    else
      render :edit
    end
  end
  
  def destroy
    if @user.delete
      if current_user? @user
        reset_session
        redirect_to cms_html_url
      else
        respond_to do |format|
          format.html { redirect_to [:admin, :users], :notice => "Successfully deleted user profile for #{@user.full_name}" }
          format.js
        end
      end
    end
  end 

  private
    
    def admin_only
      @user.puid = params[:user][:puid] if admin?
      @user.role = params[:user][:role] if admin?
    end

end
