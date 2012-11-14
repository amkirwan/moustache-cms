class Admin::CustomFieldsController < AdminBaseController 

  load_resource :page
  load_resource :author
  load_resource :article
  load_resource :theme_collection
  load_resource :theme_asset, :through => :theme_collection
  load_and_authorize_resource :custom_field, :through => [:page, :author, :article, :theme_asset]
  before_filter :assign_base_class

  respond_to :js, :only => [:new, :destroy]

  def new
    respond_with(:admin, @custom_field)
  end

  def create
    render :nothing => true
  end

  def destroy
    respond_with(:admin, @custom_field) do |format|
      if @custom_field.destroy
        flash[:notice] = "Successfully deleted the custom field #{@custom_field.name}"
        format.html { redirect_to [:admin, @base_class] }
      end
    end
  end

    private
      def assign_base_class
        if params[:page_id]
          @base_class = @page
        elsif params[:theme_collection_id]
          @base_class = @theme_asset
        elsif params[:author_id]
          @base_class = @author
        else params[:article_id]
          @base_class = @article
        end
      end
end
