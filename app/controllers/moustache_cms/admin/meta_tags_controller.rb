module MoustacheCms
  class Admin::MetaTagsController < AdminBaseController 

    load_resource :site
    load_resource :page
    load_resource :article
    load_and_authorize_resource :meta_tag, :through => [:site, :page, :article]
    before_filter :assign_base_class

    respond_to :html, :except => :show
    respond_to :xml, :json
    respond_to :js, :only => [:new, :destroy]

    def new
      respond_with(:admin, @meta_tag)
    end

    def edit
      respond_with(:admin, @meta_tag)
    end

    def create
      respond_with(:admin, @meta_tag) do |format|
        if @meta_tag.save
          meta_tag_redirect format, "Successfully created the meta tag #{@meta_tag.name}", :edit, :admin, @base_class
        end
      end
    end

    def update
      respond_with(:admin, @meta_tag) do |format|
        if @meta_tag.update_attributes(params[:meta_tag])
          meta_tag_redirect format, "Successfully updated the meta tag #{@meta_tag.name}", :edit, :admin, @base_class
        end
      end
    end
    
    def destroy
      respond_with(:admin, @meta_tag) do |format|
        if @meta_tag.destroy
          meta_tag_redirect format, "Successfully deleted the meta tag #{@meta_tag.name}", :edit, :admin, @base_class
        end
      end
    end

    private

    def meta_tag_redirect(format, notice, *route)
      format.html { redirect_to route, :notice => notice }
    end

    def assign_base_class
      if params[:page_id]
        @base_class = @page
      elsif params[:article_id]
        @base_class = @article
      else
        @base_class = @site
      end
    end
      
  end
end
