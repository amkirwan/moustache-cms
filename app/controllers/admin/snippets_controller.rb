class Admin::SnippetsController < AdminBaseController   
  
  load_and_authorize_resource 

  respond_to :html, :xml, :json
  
  def index               
    respond_with(:admin, @snippets)
  end  
  
  def show
    respond_with(:admin, @snippet) do |format|
      format.html { render :edit }
    end
  end
  
  def new
    respond_with(:admin, @snippet)
  end
  
  def create   
    created_updated_by_for @snippet
    @snippet.site_id = @current_site.id
    respond_with(:admin, @snippet) do |format|
      if @snippet.save
        format.html { redirector [:edit, :admin, @snippet], [:admin, :snippets], "Successfully created the snippet #{@snippet.name}" }
      end
    end
  end
  
  def edit
    respond_with(:admin, @snippet)
  end
  
  def update                
    @snippet.updated_by = @current_admin_user      
    respond_with(:admin, @snippet) do |format|
      if @snippet.update_attributes(params[:snippet]) 
        format.html { redirector [:edit, :admin, @snippet], [:admin, :snippets], "Successfully updated the snippet #{@snippet.name}" }
      end
    end
  end
  
  def destroy
    @snippet.delete
    flash[:notice] = "Successfully deleted the snippet #{@snippet.name}"
    respond_with(:admin, @snippet)
  end
end
