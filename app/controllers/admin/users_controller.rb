class Admin::UsersController < AdminBaseController    
 
  load_and_authorize_resource 

  respond_to :html, :xml, :json
  respond_to :js, :only => :destroy

  def index               
    @users = @users.where(:site_id => current_admin_user.site_id)
    respond_with(:admin, @users)
  end  
  
  def show
    respond_with(:admin, :user) do |format|
      format.html { render :edit }
    end
  end
  
  def new
    respond_with(:admin, @user)
  end                        
  
  def create   
    # set because attr_accessible   
    admin_only
    @user.site = @current_site
    respond_with(:admin, @user) do |format|
      if @user.save
        format.html { redirect_to [:admin, :users], :notice => "Successfully created the user profile for #{@user.full_name}" }
      end
    end
  end
  
  def edit
    respond_with(:admin, @user)
  end
  
  def update                    
    admin_only
    respond_with(:admin, @user) do |format|
      if @user.update_without_password(params[:user])
        flash[:notice] = "Successfully updated the user profile for #{@user.full_name}"
        format.html { redirect_to [:admin, :users] }
      else
        format.html { render :edit}
      end
    end
  end

  def update_password
    admin_only  
    if @user.update_with_password(params[:user])
      flash[:notice] = "Successfully updated the password for #{@user.full_name}"
      sign_in(@user, :bypass => true)
      respond_with(:admin, @user)
    else
      render :change_password
    end
  end

  def destroy
    if @user.delete
      if current_admin_user? @user
        reset_session
        respond_with do |format|
          format.html { redirect_to [:new, :admin, :user_session] }
        end
      else
        flash[:notice] = "Successfully deleted the user profile for #{@user.full_name}" 
        respond_with do |format|
          format.html { redirect_to [:admin, :users] }
        end
      end
    end
  end 

  private

    def admin_only
      if admin?
        @user.username = params[:user][:username] 
        @user.role = params[:user][:role] 
      end
    end

end
