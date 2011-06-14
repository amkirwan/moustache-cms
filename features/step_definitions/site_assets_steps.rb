def find_asset_collection(c_name)
  AssetCollection.where(:name => c_name).first
end

Given /^these site assets exist in the collection "([^\"]*)" in the site "([^\"]*)" created by user "([^\"]*)"$/ do |c_name, site, puid, table|
  user = User.find_by_puid(puid)
  site = Site.match_domain(site).first
  collection = find_asset_collection(c_name)
  table.hashes.each do |hash|
    collection.site_assets << Factory.build(:site_asset, :name => hash[:name], :creator_id => user.id, :updator_id => user.id, :asset => AssetFixtureHelper.open("rails.png"))
  end
  collection.save
end

Given /^"([^\"]*)" has created the site asset "([^\"]*)"$/ do |puid, asset_name|
  user = User.find_by_puid(puid)
  When %{I go to the new admin site asset page}
  Given %{I fill in "site_asset_name" with "#{asset_name}" within "div#add_new_site_asset"}
  Given %{I attach the file "spec/fixtures/assets/rails.png" to "site_asset_asset"}
  Given %{I press "Save Asset" within "div#add_new_site_asset"}
end

When /^I view the collection "([^\"]*)" admin asset collection site assets page$/ do |c_name|
  collection = find_asset_collection(c_name)
  When %{I go to the admin asset collection site assets page for "#{collection.to_param}"}
end

Then /^navigate to the admin asset collection site assets page for "([^\"]*)"$/ do |c_name|
  collection = find_asset_collection(c_name)
  Then %{I should be on the admin asset collection site assets page for "#{collection.to_param}"}
end

Then /^I should view the collection "([^"]*)" admin asset collection site assets page$/ do |c_name|
  collection = find_asset_collection(c_name)
  Then %{I should be on the admin asset collection site assets page for "#{collection.to_param}"}
end


Then /^I should see the url for the site asset file "([^\"]*)"$/ do |site_asset_name|
  site_asset = find_site_asset(site_asset_name)
  Then %{I should see "http://#{site_asset.site.full_subdomain}#{site_asset.asset.url}"}
end

Then /^(?:|I )should now be editing the site asset "([^\"]*)"$/ do |site_asset_name|
  site_asset = find_site_asset(site_asset_name)
  Then %{I should be on the edit admin site asset page for "#{site_asset.to_param}"} 
end