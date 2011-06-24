class Admin::SnippetsController < AdminBaseController   
  
  def index               
  end  
  
  def show
    render :edit
  end
  
  def new
  end
  
  def create   
    # set because attr_accessible  
    created_updated_by_for @snippet
    @snippet.site = @current_site
    if @snippet.save
      redirector [:edit, :admin, @snippet], [:admin, :snippets], "Successfully created the snippet #{@snippet.name}"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update                
    @snippet.updated_by = @current_user      
    if @snippet.update_attributes(params[:snippet]) 
      redirector [:edit, :admin, @snippet], [:admin, :snippets], "Successfully created the snippet #{@snippet.name}"
    else
      render :edit
    end
  end
  
  def destroy
    if @snippet.delete
      redirect_to [:admin, :snippets], :notice => "Successfully deleted the snippet #{@snippet.name}"
    end
  end
end