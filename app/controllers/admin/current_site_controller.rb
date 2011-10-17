class Admin::CurrentSiteController < AdminBaseController

  load_and_authorize_resource :class => 'Site'

  def edit
  end

  def update
    if @current_site.update_attributes(params[:site])
      render :edit
    end
  end

  def delete_domain
    @current_site.domains.delete_if { |domain| domain == params[:domain_name] }
    respond_to do |format|
      format.html { redirect_to [:edit, :admin, @current_site] }
      format.js
    end 
  end
end
