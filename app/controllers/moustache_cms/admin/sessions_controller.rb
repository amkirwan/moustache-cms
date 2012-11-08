module MoustacheCms
  class Admin::SessionsController < Devise::SessionsController

    before_filter :find_current_site

    def find_current_site
      @current_site ||= Site.match_domain(request.host.downcase).first
    end

    def after_sign_in_path_for(resource)
      [:admin, :pages]
    end

    def after_sign_out_path_for(resource)
      [:new, :admin, :user_session]
    end

  end
end
