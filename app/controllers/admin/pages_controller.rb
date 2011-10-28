class Admin::PagesController < AdminBaseController
  
  load_and_authorize_resource 

  respond_to :html, :xml, :json

  def index
    respond_with @pages
  end
  
  def new
    @page.build_current_state
    @page.page_parts.build
    @page.page_parts.first.name = "content"
    respond_with @page
  end
  
  def create
    @page.site_id = @current_site.id
    created_updated_by_for @page
    respond_with(@page) do |format|
      if @page.save
        format.any { redirector [:edit, :admin, @page], [:admin, :pages], "Successfully created the page #{@page.title}" }
      else
        format.any { render :new }
      end 
    end
  end
  
  def edit
    respond_with @page
  end
  
  def update
    @page.updated_by = @current_user
    respond_with(@page) do |format|
      if @page.update_attributes(params[:page]) 
        format.any { redirector [:edit, :admin, @page], [:admin, :pages], "Successfully updated the page #{@page.title}" }
      else
        format.any { render :edit }
      end
    end
  end

  def destroy
    if @page.destroy
      flash[:notice] = "Successfully deleted the page #{@page.title}"
    end
    respond_with(@page, :location => [:admin, :pages]) do |format|
      format.js { @page } 
    end
  end

  def sort
    @page = current_site.pages.find(params[:id])
    @page.sort_children(params[:children])
    
    flash.now[:notice] = "Updated Page Positions"
  end
  
end
