class Admin::UsersController < AdminBaseController    
 
  load_and_authorize_resource 

  respond_to :html, :xml, :json
  respond_to :js, :only => :destroy

  def index               
    respond_with(:admin, :users)
  end  
  
  def show
    respond_with(:admin, :user) do |format|
      format.html { render :edit }
    end
  end
  
  def new
    respond_with(:admin, :user)
  end                        
  
  def create   
    # set because attr_accessible   
    admin_only
    @user.site = @current_site
    respond_with(:admin, @user) do |format|
      if @user.save
        format.html { redirect_to [:admin, :users], :notice => "Successfully created user profile for #{@user.full_name}" }
      end
    end
  end
  
  def edit
    respond_with(:admin, :user)
  end
  
  def update                    
    admin_only
    respond_with(:admin, @user) do |format|
      if @user.update_attributes(params[:user]) 
        format.html { redirect_to [:admin, :users], :notice => "Successfully updated user profile for #{@user.full_name}" }
      end
    end
  end
  
  def destroy
    if @user.delete
      if current_admin_user? @user
        reset_session
        respond_with(:admin, @user, :location => cms_html_url)
      else
        flash[:notice] = "Successfully deleted user profile for #{@user.full_name}" 
        respond_with do |format|
          format.html { redirect_to [:admin, :users] }
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
