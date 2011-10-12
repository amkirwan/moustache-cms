module Admin::SiteAssetsHelper
  
  def site_asset_record_type?(f_model)
    if @site_asset.new_record?
      render :partial => 'new_site_asset', :object => f_model
    else
      render :partial => 'site_asset'
    end
  end
end
