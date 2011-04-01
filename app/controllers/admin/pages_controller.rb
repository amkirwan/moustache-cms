class Admin::PagesController < AdminBaseController
    
  def index
  end
  
  def new
    @page.build_page_type
    @page.build_current_state
    @page.page_parts.build
  end
  
  def create
    params[:page][:editor_ids] ||= []
    if params[:page][:parent_id].blank?
      @page.parent_id = nil
    elsif
      @page.parent_id = Page.criteria.id(params[:page][:parent_id]).first.id
    end
    @page.page_type  = PageType.find(params[:page][:page_type_attributes][:id])
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
  
  def assign_page_parts(page_parts={})
    page_parts.each_pair do |key, value|
      @page.page_parts.build({"name" => "content", "content" => "Hello"})
      #@page.page_parts.build(value)
    end
  end
end
