class Admin::CurrentSiteController < AdminBaseController

  load_and_authorize_resource :class => 'Site'

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

end
