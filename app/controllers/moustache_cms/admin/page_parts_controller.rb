module MoustacheCms
  class Admin::PagePartsController < AdminBaseController 

    load_and_authorize_resource :page
    load_and_authorize_resource :page_part, :through => :page

    before_filter :selected_page_part, :only => :edit

    respond_to :html, :except => :show
    respond_to :xml, :json
    respond_to :js, :only => [:edit, :create, :destroy]

    def show
      respond_with(:admin, @page, @page_part)
    end

    def create
      @page_part.name = "page part #{@page.page_parts.size}"
      @page_part.filter_name = "markdown"
      respond_with(:admin, @page, @page_part) do |format|
        if @page_part.save
          @selected_page_part = @page_part
          format.html { redirect_to edit_admin_page_path(@page, :view => @page_part.name), :notice => "Successfully created the page part #{@page_part.name}" }
        end
      end
    end

    def edit
      respond_with(:admin, @page, @page_part)
    end

    def destroy
      @page_part.destroy
      @selected_page_part = @page.page_parts.last
      flash[:notice] = "Successfully deleted the page part #{@page_part.name}"
      respond_with(:admin, @page, @page_part) do |format|
        format.html { redirect_to [:edit, :admin, @page] }
      end
    end

    private 

    def selected_page_part
      return @selected_page_part = @page.page_parts.first if params[:view].nil? || params[:view].empty?

      @selected_page_part = @page.page_parts.find(params[:view])
      if @selected_page_part.nil?
        @selected_page_part = @page.page_parts.first
      else
        @selected_page_part 
      end
    end
  
  end
end
