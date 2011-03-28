class Admin::PagesController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter
  load_and_authorize_resource 
  
  layout "admin/admin"
  
  def index
  end
  
  def new
    @page.build_page_type
    @page.build_current_state
    @page.page_parts.build
  end
  
  def create
    params[:page][:editor_ids] ||= []
    @page.page_type = PageType.find(params[:page][:page_type_attributes][:id])
    @page.filter = Filter.find(params[:page][:filter])
    @page.current_state = CurrentState.find(params[:page][:current_state_attributes][:id])
    assign_page_parts(params[:page][:page_parts_attributes])
    assign_editors(params[:page][:editor_ids])
    created_updated_by_for @page
    if @page.save
      flash[:notice] = "Successfully created page #{@page.title}"
      redirect_to admin_pages_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  private 
  def assign_editors(editor_ids)
    editor_ids.each { |editor_id| @page.editor_ids << editor_id unless @page.editor_ids.include?(editor_id) }
    @page.editor_ids << current_user.puid unless @page.editor_ids.include?(current_user.puid) 
  end
  
  def assign_page_parts(page_parts)
    page_parts.each_pair do |key, value|
      @page.page_parts.create(value)
    end
  end
end
