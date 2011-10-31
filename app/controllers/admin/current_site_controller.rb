class Admin::CurrentSiteController < AdminBaseController

  load_and_authorize_resource :class => 'Site'

  respond_to :html, :except => [:index, :show]
  respond_to :xml, :json, :except => :index

  def edit
    respond_with(:admin, @current_site)
  end

  def update
    respond_with(:admin, @current_site) do |format|
      if @current_site.update_attributes(params[:site])
        format.html { redirect_to [:edit, :admin, @current_site], :notice => "Successfully updated the site #{@current_site.name}" }
      end
    end
  end


  def destroy
    @current_site.destroy
    reset_session
    respond_with(:admin, @current_site, :location => cms_html_url)
  end

end
