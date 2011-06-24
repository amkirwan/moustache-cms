class Admin::PagesController < AdminBaseController
  
  def index
  end
  
  def new
    @page.build_current_state
    @page.page_parts.build
  end
  
  def create
    params[:page][:editor_ids] ||= []
    if params[:page][:parent_id].blank?
      @page.parent_id = nil
    elsif
      @page.parent_id = Page.find_by_id(params[:page][:parent_id]).id
    end
    @page.site = @current_site  
    assign_current_state(params[:page][:current_state_attributes][:name])
    assign_page_parts(params[:page][:page_parts_attributes])
    assign_editors(params[:page][:editor_ids])
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
    update_current_state(params[:page][:current_state_attributes][:name])
    update_page_parts(params[:page][:page_parts_attributes])
    update_editors(params[:page][:editor_ids])
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
  
  private 
    def assign_editors(editor_ids)
      editor_ids.each do |editor_id|
        editor = User.find(editor_id)
        @page.editors << editor unless @page.editors.include?(editor)
      end
      @page.editors << current_user unless @page.editors.include?(current_user) 
    end
  
    def assign_page_parts(page_parts={})
      page_parts.each_value do |hash|
        @page.page_parts.create(hash)
      end
    end
  
    def update_page_parts(page_parts={})
      page_parts.each do |index, hash|
        @page.page_parts[index.to_i].write_attributes(hash)
      end
    end
    
    def update_editors(editor_ids)
      editor_ids = [] if editor_ids.nil?
      editor_bson_ids = []
      editor_ids.each do |e_id|
        editor_bson_ids << User.find(e_id).id
      end
      remove_editor_ids = @page.editor_ids - editor_bson_ids
      remove_editor_ids.each do |editor_id|
        @page.delete_association_of_editor_id(editor_id)
      end
      assign_editors(editor_ids)
    end    
    
    def assign_current_state(current_state_name)    
      @page.current_state = CurrentState.find_by_name(current_state_name)
    end   
    
    def update_current_state(current_state_name)
      cs = CurrentState.find_by_name(current_state_name)
      if cs.name != @page.current_state.name
        @page.current_state.attributes = { :id => cs.id, :name => cs.name } 
      end
    end
end
