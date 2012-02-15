class Admin::PagesController < AdminBaseController
  
  before_filter :root_pages, :only => :index

  load_and_authorize_resource 

  before_filter :selected_page_part, :only => :edit 

  respond_to :html, :except => [:show, :sort, :new_meta_tag, :update]
  respond_to :xml, :json
  respond_to :js, :only => [:show, :edit, :destroy, :sort, :new_meta_tag, :new_custom_field]

  def index
    @page_created_updated_id = cookies[:page_created_updated_id]
    @page = Page.where(:site_id => current_site.id).find(@page_created_updated_id) unless @page_created_updated_id.nil?
    respond_with(:admin, @pages)
  end

  def show
    respond_with(:admin, @page)
  end
  
  def new
    parent_page
    @page.build_current_state
    @page.page_parts.build(:name => 'content')
    @selected_page_part = @page.page_parts.first
    respond_with(:admin, @page)
  end
  
  def create
    @page.site_id = current_site.id
    created_updated_by_for @page
    respond_with(:admin, @page) do |format|
      if @page.save
        cookies[:page_created_updated_id] = @page.id
        cookies[:page_parent_id] = @page.parent.id
        format.html { redirect_to redirector_path(@page), :notice => "Successfully created the page #{@page.title}" }
      else
        @parent_page = Page.where(:site_id => current_site.id).find(params[:page][:parent_id])
      end
    end
  end
  
  def edit
    parent_page
    respond_with(:admin, @page)
  end
  
  def update
    @page.updated_by = @current_admin_user
    @page_title_was =  @page.title
    respond_with(:admin, @page) do |format|
      if @page.update_attributes(params[:page]) 
        set_page_cookies unless params[:commit] == "Save and Continue Editing"
        flash[:notice] = "Successfully updated the page #{@page.title}"
        selected_page_part 
        format.html { redirect_to redirector_path(@page), :notice => "Successfully updated the page #{@page.title}" }
      else
        selected_page_part 
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
    render 'admin/meta_tags/new.js'
  end

  def new_custom_field
    @base_class = Page.new
    @custom_field = CustomField.new
    render 'admin/custom_fields/new'
  end

  private 

    def root_pages
      @root_pages = @pages = Page.roots.where(:site_id => @current_site.id)
    end

    def set_page_cookies
      cookies[:page_created_updated_id] = @page.id
      cookies[:page_parent_id] = @page.parent.id
    end

    def parent_page
      home_page = current_site.pages.where(:full_path => '/').first
      if @page.new_record? && params[:parent_id].nil?
        @parent_page = home_page
      elsif !params[:parent_id].nil?
        @parent_page = Page.where(:site_id => current_site.id).find(params[:parent_id])
      else
        @parent_page = @page.parent
      end
    end

    def redirector_path(object)
      params[:commit] == "Save and Continue Editing" ? edit_admin_page_path(object, :view => @selected_page_part.id) : [:admin, :pages]
    end
end
