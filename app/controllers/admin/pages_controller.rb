class Admin::PagesController < AdminBaseController
  
  def index
  end
  
  def new
    @page.build_current_state
    @page.meta_tags.build
    @page.page_parts.build
  end
  
  def create
    @page.site_id = @current_site.id
    created_updated_by_for @page
    if @page.save
      redirect_to admin_pages_path, :notice => "Successfully created page #{@page.title}"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    @page.updated_by = @current_user
    if @page.update_attributes(params[:page]) 
      redirect_to admin_pages_path, :notice => "Successfully updated the page #{@page.title}"
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
