def find_theme_asset(theme_asset_name)
  ThemeAsset.where(:name => theme_asset_name).first
end

def content_type(file)
  file =~ /\.(.*)/
  case $1
  when "css"
    type = "text/css"
  when "js"
    type = "text/javascript"
  when "jpg"
    type = "image/jpg"
  when "png"
    type = "image/png"
  end
  type
end

Given /^these theme assets exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, username, table|
  user = User.find_by_username(username)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:theme_asset, :site => site, 
                          :name => hash[:name], 
                          :created_by => user, 
                          :updated_by => user, 
                          :asset => AssetFixtureHelper.open(hash[:file]),
                          :content_type => content_type(hash[:file]))
  end
end  

Given /^"([^\"]*)" has created the theme asset "([^\"]*)"$/ do |username, asset_name|
  user = User.find_by_username(username)
  When %{I go to the new admin theme asset page}
  Given %{I fill in "theme_asset_name" with "#{asset_name}"} 
  Given %{I attach the file "spec/fixtures/assets/rails.png" to "theme_asset_asset"}
  Given %{I press "Save Theme Asset"}
end    

Then /^I should see the url for the theme asset file "([^\"]*)"$/ do |theme_asset_name|
  theme_asset = find_theme_asset(theme_asset_name)
  Then %{I should see "http://#{theme_asset.site.full_subdomain}#{theme_asset.asset.url}"}
end

Then /^(?:|I )should now be editing the theme asset "([^\"]*)"$/ do |theme_asset_name|
  theme_asset = find_theme_asset(theme_asset_name)
  Then %{I should be on the edit admin theme asset page for "#{theme_asset.to_param}"} 
end
