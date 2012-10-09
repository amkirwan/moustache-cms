class Admin::PagesController < AdminBaseController
  
  before_filter :root_pages, :only => :index

  load_and_authorize_resource 

  before_filter :remove_selected_page_part, :except => :edit

  respond_to :html, :except => [:show, :sort, :new_meta_tag, :new_custom_field]
  respond_to :xml, :json
  respond_to :js, :only => [:preview, :show, :edit, :destroy, :sort, :new_meta_tag, :new_custom_field]

  def index
    page_created_updated
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

  def edit
    selected_page_part
    parent_page
    respond_with(:admin, @page)
  end
   
  def create
    assign_protected_attributes
    respond_with(:admin, @page) do |format|
      if @page.save
        set_page_cookies
        format.html { redirect_to redirector_path(@page), :notice => "Successfully created the page #{@page.title}" }
      else
        @parent_page = Page.where(:site_id => current_site.id).find(params[:page][:parent_id])
      end
    end
  end
  
  def update
    @page.updated_by = @current_admin_user
    @page_title_was =  @page.title
    respond_with(:admin, @page) do |format|
      if @page.update_attributes(params[:page]) 
        set_page_cookies if params[:continue]
        set_page_part if params[:continue]
        flash[:notice] = "Successfully updated the page #{@page.title}"
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

  def preview
    @page = Page.new(params[:page])
    assign_protected_attributes
    @page.save_preview
  end

  def sort
    @page = current_site.find_page(params[:id])
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

    def assign_protected_attributes
      @page.site = current_site
      created_updated_by_for @page
    end

    def set_page_part
      if params[:view]
        session[:selected_page_part_id] = params[:view]
      else
        session[:selected_page_part_id] = @page.page_parts.first.id
      end 
    end

    def page_created_updated
      @page_created_updated_id = cookies[:page_created_updated_id]
      begin
        @page = current_site.find_page(@page_created_updated_id) unless @page_created_updated_id.nil?
      rescue
        @page = current_site.pages.first
      end
    end

    def selected_page_part
      return @selected_page_part = @page.page_parts.first if session[:selected_page_part_id].nil? || session[:selected_page_part_id].empty?

      begin
        @selected_page_part = @page.page_parts.find(session[:selected_page_part_id])
      rescue
        @selected_page_part = @page.page_parts.first
      ensure
        session.delete(:selected_page_part_id)
      end

      if @selected_page_part.nil?
        @selected_page_part = @page.page_parts.first
      else
        @selected_page_part 
      end
    end

    def remove_selected_page_part
      session.delete(:selected_page_part_id)
    end


    def root_pages
      @root_pages = @pages = Page.roots.where(:site_id => @current_site.id).order_by(:created_at => :asc)
    end

    def set_page_cookies
      cookies[:page_created_updated_id] = @page.id
      cookies[:page_parent_id] = @page.parent.id unless @page.root?
    end

    def parent_page
      if @page.new_record? && params[:parent_id].nil?
        @parent_page = current_site.pages.where(:full_path => '/').first # homepage
      elsif !params[:parent_id].nil?
        @parent_page = Page.where(:site_id => current_site.id).find(params[:parent_id])
      else
        @parent_page = @page.parent
      end
    end

end
