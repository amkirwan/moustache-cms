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
    @page.attributes = { :site => @current_site, :current_state => CurrentState.find(params[:page][:current_state_attributes][:name]) }
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
    @page.update_attributes(params[:page])
    @page.current_state = CurrentState.find(params[:page][:current_state_attributes][:name]) 
    update_page_parts(params[:page][:page_parts_attributes])
    update_editors(params[:page][:editor_ids])
    @page.updated_by(current_user)
    if @page.save
      flash[:notice] = "Successfully updated the page #{@page.title}"
      redirect_to admin_pages_path
    else
      render :edit
    end
  end

  def destroy
    if @page.destroy
      flash[:notice] = "Successfully deleted the page #{@page.title}"
      redirect_to admin_pages_path
    end
  end
  
  private 
    def assign_editors(editor_ids)
      editor_ids.each do |editor_id|
        editor = User.find_by_puid(editor_id)
        @page.editors << editor unless @page.editors.include?(editor)
      end
      @page.editors << current_user unless @page.editors.include?(current_user) 
    end
  
    def assign_page_parts(page_parts={})
      page_parts.each_value do |hash|
        page_part = PagePart.new
        page_part.write_attributes(hash)
        page_part.filter = Filter.find(hash[:filter])
        @page.page_parts << page_part
      end
    end
  
    def update_page_parts(page_parts={})
      page_parts.each do |index, hash|
        hash[:filter] = Filter.find(hash[:filter])
        @page.page_parts[index.to_i].write_attributes(hash)
      end
    end
    
    def update_editors(editor_ids)
      remove_editor_ids = @page.editor_ids - editor_ids
      remove_editor_ids.each do |editor_id|
        @page.delete_association_of_editor_id(editor_id)
      end
      assign_editors(editor_ids)
    end

end
