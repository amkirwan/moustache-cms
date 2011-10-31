class Admin::PagePartsController < AdminBaseController 

  load_and_authorize_resource :page
  load_and_authorize_resource :page_part, :through => :page

  respond_to :html, :xml, :json

  def new
    respond_with(:admin, @page, @page_parts)
  end

  def show
    respond_with(:admin, @page, @page_part)
  end

  def edit
    respond_with(:admin, @page, @page_part)
  end

  def create
    respond_with(:admin, @page, @page_part) do |format|
      if @page_part.save
        format.html { redirect_to [:edit, :admin, @page], :notice => "Successfully created the page part #{@page_part.name}" }
      end
    end
  end

  def update
    respond_with(:admn, @page, @page_part) do |format|
      if @page_part.update_attributes(params[:page_part])
        format.html { redirect_to [:edit, :admin, @page], :notice => "Successfully updated the page part #{@page_part.name}" }
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
