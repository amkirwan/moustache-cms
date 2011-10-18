class Admin::CurrentSiteController < AdminBaseController

  load_and_authorize_resource :class => 'Site'


  def new_domain
    respond_to do |format|
      format.js 
    end
  end

  def edit
  end

  def update
    if @current_site.update_attributes(params[:site])
      flash[:notice] = "Successfully updated the site #{@current_site.name}"
      redirect_to [:edit, :admin, @current_site]
    else
      render :edit
    end 
  end


  def destroy
    if @current_site.destroy
      reset_session
      redirect_to cms_html_url
    end
  end


  def delete_domain_name
    @current_site.domains.delete_if { |domain| domain == params[:domain_name] }
    respond_to do |format|
      format.html { redirect_to [:edit, :admin, @current_site] }
      format.js
    end 
  end
end
