class Admin::DomainsController < AdminBaseController

  before_filter :authorize_current_site

  def new
  end

  def create
    @current_site.domain_names << params[:site][:domain_name]
    if @current_site.save
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @current_site], :notice => "Successfully created the domain name #{params[:site][:domain_name]}" }
        format.js
      end
    else
      render :new
    end
  end

  def destroy
    @domain = @current_site.domain_names[params[:id].to_i]
    @current_site.domain_names.delete_at(params[:id].to_i)

    if  @current_site.save
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @current_site], :notice => "Successfully deleted the domain name #{@domain}" }
        format.js
      end
    end
  end

  private
    def authorize_current_site
      @current_site = Site.find(params[:site_id])
      authorize! :edit, @current_site
    end
end
