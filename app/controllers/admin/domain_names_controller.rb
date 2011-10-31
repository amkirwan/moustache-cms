class Admin::DomainNamesController < AdminBaseController

  before_filter :authorize_current_site

  respond_to :html
  respond_to :xml, :json, :except => :new

  def new
    respond_with(:admin, @current_site)
  end

  def create
    @current_site.domain_names << params[:site][:domain_name]
    respond_with(:admin, @current_site) do |format|
      if @current_site.save
        flash[:notice] = "Successfully created the domain name #{params[:site][:domain_name]}"
        format.html { redirect_to [:edit, :admin, @current_site] }
        format.js
      end
    end
  end

  def destroy
    @domain_name = @current_site.domain_names[params[:id].to_i]
    @current_site.domain_names.delete_at(params[:id].to_i)

    respond_with(:admin, @current_site) do |format|
      if @current_site.save
        flash[:notice] = "Successfully deleted the domain name #{@domain_name}" 
      end
      format.html { redirect_to [:edit, :admin, @current_site] }
      format.js
    end
  end

  private
    def authorize_current_site
      @current_site = Site.find(params[:site_id])
      authorize! :edit, @current_site
    end
end
