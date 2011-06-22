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
    #@snippet.filter = Filter.find_admin_filter(params[:snippet][:filter]) 
    @snippet.site = @current_site
    if @snippet.save
      redirect_to [:admin, :snippets], :notice => "Successfully created the snippet #{@snippet.name}" 
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update                     
    if @snippet.update_attributes(params[:snippet]) 
      redirect_to [:admin, :snippets], :notice => "Successfully updated snippet #{@snippet.name}"
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