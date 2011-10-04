class Admin::PagesController < AdminBaseController
  
  load_and_authorize_resource 
  
  def index
  end
  
  def new
    @page.build_current_state
    @page.page_parts.build
  end
  
  def create
    @page.site_id = @current_site.id
    created_updated_by_for @page
    if @page.save
      redirector [:edit, :admin, @page], [:admin, :pages], "Successfully created the page #{@page.title}"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    @page.updated_by = @current_user
    if @page.update_attributes(params[:page]) 
      redirector [:edit, :admin, @page], [:admin, :pages], "Successfully updated the page #{@page.title}"
    else
      render :edit
    end
  end

  def destroy
    if @page.destroy
      redirect_to admin_pages_path, :notice => "Successfully deleted the page #{@page.title}"
    end
  end
  
end
