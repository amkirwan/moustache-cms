class Admin::CurrentSiteController < AdminBaseController

  load_and_authorize_resource :class => 'Site'

  def edit
  end

end
