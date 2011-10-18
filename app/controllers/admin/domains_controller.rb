class Admin::DomainsController < AdminBaseController

  def new
    @current_site = Site.find(params[:site_id])
    authorize! :new, @current_site
  end

  def destroy
    @current_site = Site.find(params[:site_id])
    @domain = @current_site.domains[params[:id].to_i]

    authorize! :destroy, @current_site
    if @current_site.domains.delete_at(params[:id].to_i)
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @current_site], :notice => "Successfully deleted the domain #{@domain}" }
        format.js
      end
    end
  end
end
