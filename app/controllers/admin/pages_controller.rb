class Admin::PagesController < AdminBaseController
  
  load_and_authorize_resource 

  before_filter :selected_page_part, :only => [:edit, :update]

  respond_to :html, :except => [:show, :sort, :new_meta_tag, :update]
  respond_to :xml, :json
  respond_to :js, :only => [:edit, :destroy, :sort, :new_meta_tag]

  def index
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
        format.html { redirect_to redirector_path(@page), :notice => "Successfully created the page #{@page.title}" }
      end
    end
  end
  
  def edit
    parent_page
    respond_with(:admin, @page)
  end
  
  def update
    @page.updated_by = @current_admin_user
    respond_with(:admin, @page) do |format|
      if @page.update_attributes(params[:page]) 
        flash[:notice] = "Successfully updated the page #{@page.title}"
         format.html { redirect_to redirector_path(@page), :notice => "Successfully updated the page #{@page.title}" }
        #format.html { redirect_to edit_admin_page_path(@page, :view => @selected_page_part.name) }
      else
        format.html { render :edit }
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
      @selected_page_part = params[:view].nil? ? @page.page_parts.first : @page.page_parts.where(:name => params[:view]).first
    end

    def parent_page
      home_page = current_site.pages.where(:full_path => '/').first
      if @page.new_record?
        @parent_page = home_page
      else
        @parent_page = @page.parent
      end
    end

    def redirector_path(object)
     params[:commit] == "Save and Continue Editing" ? edit_admin_page_path(object, :view => @selected_page_part.name) : [:admin, :pages]
    end
end
