Given /^these theme asset exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, puid, table|
  user = User.find_by_puid(puid)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:theme_asset, :site => site, :name => hash[:name], :created_by => user, :updated_by => user, :source => AssetFixtureHelper.open("rails.png"))
  end
end