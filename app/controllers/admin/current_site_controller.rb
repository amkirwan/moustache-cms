class Admin::CurrentSiteController < AdminBaseController

  before_filter :new_site, :only => [:new, :create]
  load_and_authorize_resource :class => 'Site'

  respond_to :html, :except => :show
  respond_to :xml, :json, :except => :show

  def index
    @sites = @current_sites
    respond_with(:admin, @sites)
  end

  def new
    respond_with(:admin, @site)
  end

  def create
    if @site.save
      flash[:notice] = "Successfully created the site #{@site.name}" 
      current_admin_user.clone_and_add_to_site(@site)
    end
    respond_with(:admin, @site, :location => [:admin, :sites])
  end

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

  private
    def new_site
      @site = params[:site] ? Site.new(params[:site]) : Site.new
    end

end
