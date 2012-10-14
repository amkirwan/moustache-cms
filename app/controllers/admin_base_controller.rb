class AdminBaseController < ApplicationController
  include MoustacheCms::FriendlyFilename
  protect_from_forgery   

  force_ssl if Rails.env == 'production'
    
  before_filter :authenticate_admin_user!
  before_filter :set_admin_user_time_zone
  after_filter :discard_flash_message

  check_authorization :unless => :devise_controller? 
  
  layout "admin/admin"
  
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}" 
    render :file => "#{Rails.root}/public/403", :status => 403, :layout => false
  end
  
  protected 
      
    def admin?     
      current_admin_user.role?("admin")
    end

    def created_updated_by_for(obj)
      obj.created_by_id = current_admin_user.id
      obj.updated_by_id = current_admin_user.id
    end
  
    def logout
      reset_session
      cookies.to_hash.each_key do |k| 
        cookies.delete(k.to_sym)
      end
    end

    def discard_flash_message
      if request.xhr? && response != :found
        flash.discard(:notice)
      end
    end

    def try_theme_asset_cache(asset_param, asset)
      if !params[asset_param.to_sym][:asset_cache].empty? && params[asset_param.to_sym][:asset].nil?
        set_from_cache(:cache_name => params[asset_param.to_sym][:asset_cache], :asset => asset) 
      end
    end 

    def asset_create_respond_with(collection, asset, redirect, &block)
      respond_with(:admin, collection, asset) do |format|
        if asset.save
          format.html { redirect_to [:admin, collection, redirect.to_sym], :notice => yield }
        end
      end
    end
 
    def redirector_path(object)
     params[:continue] ? [:edit, :admin, object] : [:admin, object.class.name.tableize.to_sym]
    end
    
    def redirector(path_continue, path_redirect, notice=nil)
      if params[:continue]
        redirect_to path_continue, :notice => notice
      else
        redirect_to path_redirect, :notice => notice
      end
    end

    def creator_updator_set_id(site_asset)
      site_asset.creator_id = current_admin_user.id
      site_asset.updator_id = current_admin_user.id
    end

    def move_directory(old_name, new_name, site_id, dir)
      if File.exists?(File.join(Rails.root, 'public', dir, site_id.to_s, old_name))
        if old_name != friendly_filename(new_name)
          old_dir = File.join(Rails.root, 'public', dir, site_id.to_s, old_name)
          new_dir = File.join(Rails.root, 'public', dir, site_id.to_s, friendly_filename(new_name))
          FileUtils.mv(old_dir, new_dir)
        end
      end
    end

    def set_admin_user_time_zone
      Time.zone = current_admin_user.time_zone if admin_user_signed_in?
    end

end
