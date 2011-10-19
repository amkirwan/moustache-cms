module Admin::SiteAssetsHelper
  
  def list_site_assets
    if @asset_collection.site_assets.empty?
      content_tag :div, :class => 'add_some' do
        content_tag :h4 do
          link_to 'Add Some Assets', [:new, :admin, @asset_collection, :site_asset]
        end
      end
    else
      render :partial => 'admin/asset_collections/site_asset', :collection => @asset_collection.site_assets
    end
  end
  
  def site_asset_record_type?(f_model)
    if @site_asset.new_record?
      render :partial => 'new_site_asset', :object => f_model
    else
      render :partial => 'site_asset'
    end
  end
end
