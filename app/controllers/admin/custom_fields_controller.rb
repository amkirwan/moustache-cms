class Admin::CustomFieldsController < AdminBaseController 

  load_resource :page
  load_resource :article
  load_and_authorize_resource :custom_field, :through => [:page, :article]
  before_filter :assign_base_class

  respond_to :html, :except => :show
  respond_to :js, :only => [:new, :destroy]

  def new
    respond_with(:admin, @custom_field)
  end

  def destroy
    @custom_field.destroy
    flash[:notice] = "Successfully deleted the custom field #{@custom_field.name}"
    respond_with(:admin, @custom_field)
  end

  private
    def assign_base_class
      if params[:page_id]
        @base_class = @page
      else params[:article_id]
        @base_class = @article
      end
    end
end
