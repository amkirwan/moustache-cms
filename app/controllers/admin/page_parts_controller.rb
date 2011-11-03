class Admin::PagePartsController < AdminBaseController 

  load_and_authorize_resource :page
  load_and_authorize_resource :page_part, :through => :page

  respond_to :html, :except => :show
  respond_to :xml, :json
  respond_to :js, :only => [:new, :destroy]

  def new
    if request.xhr?
      @page_part.name = 'page part name'
      @page_part.filter_name = 'markdown'
      @page.page_parts << @page_part
    end
    respond_with(:admin, @page, @page_part)
  end

  def show
    respond_with(:admin, @page, @page_part)
  end

  def create
    @page_part.filter_name = "markdown"
    respond_with(:admin, @page, @page_part) do |format|
      if @page_part.save
        format.html { redirect_to edit_admin_page_path(@page, :view => @page_part.name), :notice => "Successfully created the page part #{@page_part.name}" }
      end
    end
  end

  def destroy
    @page_part.destroy
    flash[:notice] = "Successfully deleted the page part #{@page_part.name}"
    respond_with(:admin, @page, @page_part) do |format|
      format.html { redirect_to [:edit, :admin, @page] }
    end
  end
  
end
