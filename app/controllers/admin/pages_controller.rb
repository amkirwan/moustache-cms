class Admin::PagesController < AdminBaseController
  
  load_and_authorize_resource 

  respond_to :html, :except => [:show, :sort, :new_meta_tag]
  respond_to :xml, :json
  respond_to :js, :only => [:destroy, :sort, :new_meta_tag]

  def index
    respond_with(:admin, @pages)
  end

  def show
    respond_with(:admin, @page)
  end
  
  def new
    parent_page
    @page.build_current_state
    @page.page_parts.build
    @page.page_parts.first.name = "content"
    respond_with(:admin, @page)
  end
  
  def create
    @page.site_id = @current_site.id
    created_updated_by_for @page
    respond_with(:admin, @page) do |format|
      if @page.save
        format.html { redirect_to redirector_path(@page), :notice => "Successfully created the page #{@page.title}" }
      end
    end
  end
  
  def edit
    parent_page
    @selected_page_part = selected_page_part
    respond_with(:admin, @page)
  end
  
  def update
    @page.updated_by = @current_user
    respond_with(:admin, @page) do |format|
      if @page.update_attributes(params[:page]) 
        format.html { redirect_to redirector_path(@page), :notice => "Successfully updated the page #{@page.title}" }
      end
    end
  end

  def destroy
    @page.destroy
    flash[:notice] = "Successfully deleted the page #{@page.title}"
    respond_with(:admin, @page) 
  end

  def sort
    @page = current_site.pages.find(params[:id])
    @page.sort_children(params[:children])
    
    flash.now[:notice] = "Updated Page Positions"
  end

  def new_meta_tag
    @base_class = Page.new
    @meta_tag = MetaTag.new
  end

  private 

    def selected_page_part
      params[:view].nil? ? @page.page_parts.first : @page.page_parts.where(:name => params[:view]).first
    end

    def parent_page
      @parent_page = @page.parent.nil? ? @current_site.pages.where(:title => "Home Page").first : @page.parent
    end
end
