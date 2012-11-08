module MoustacheCms
  class Admin::SnippetsController < AdminBaseController   
    
    load_and_authorize_resource 

    respond_to :html, :xml, :json
    
    def index               
      @snippets = @snippets.where(:site_id => current_admin_user.site_id).order_by(:name => 'ASC')
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
   
    def edit
      respond_with(:admin, @snippet)
    end
      
    def create   
      created_updated_by_for @snippet
      @snippet.site = @current_site
      respond_with(:admin, @snippet) do |format|
        if @snippet.save
          format.html { redirector [:edit, :admin, @snippet], [:admin, :snippets], "Successfully created the snippet #{@snippet.name}" }
        end
      end
    end
   
    def update                
      assign_updated_by @snippet
      respond_with(:admin, @snippet) do |format|
        if @snippet.update_attributes(params[:snippet]) 
          format.html { redirector [:edit, :admin, @snippet], [:admin, :snippets], "Successfully updated the snippet #{@snippet.name}" }
        end
      end
    end
    
    def destroy
      @snippet.destroy
      flash[:notice] = "Successfully deleted the snippet #{@snippet.name}"
      respond_with(:admin, @snippet)
    end
  end
end
