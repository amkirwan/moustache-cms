class Admin::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    admin_pages_url
  end

  def after_sign_out_path_for(resource)
    request.protocol + request.hosto_with_port
  end

end
