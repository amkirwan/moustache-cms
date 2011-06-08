require 'spec_helper'

describe Admin::AssetCollectionsController do
  
  let(:site) { mock_model(Site, :id => "1") }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:asset_collection) { mock_model("AssetCollection", :site_id => site.id).as_null_object }
  
  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)
  end

end
