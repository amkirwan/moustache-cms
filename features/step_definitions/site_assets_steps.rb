def find_site_asset(site_asset_name)
  SiteAsset.where(:name => site_asset_name).first
end

Given /^these site assets exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, puid, table|
  user = User.find_by_puid(puid)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:site_asset, :site => site, :name => hash[:name], :created_by => user, :updated_by => user, :source => AssetFixtureHelper.open("rails.png"))
  end
end

Given /^"([^\"]*)" has created the site asset "([^\"]*)"$/ do |puid, asset_name|
  user = User.find_by_puid(puid)
  When %{I go to the new admin site asset page}
  Given %{I fill in "site_asset_name" with "#{asset_name}" within "div#add_new_site_asset"}
  Given %{I attach the file "spec/fixtures/assets/rails.png" to "site_asset_source"}
  Given %{I press "Save Asset" within "div#add_new_site_asset"}
end

Then /^I should see the url for the file "([^\"]*)"$/ do |site_asset_name|
  site_asset = find_site_asset(site_asset_name)
  Then %{I should see "http://#{site_asset.site.full_subdomain}#{site_asset.source.url}"}
end

Then /^(?:|I )should now be editing the site asset "([^\"]*)"$/ do |site_asset_name|
  site_asset = find_site_asset(site_asset_name)
  Then %{I should be on the edit admin site asset page for "#{site_asset.to_param}"} 
end