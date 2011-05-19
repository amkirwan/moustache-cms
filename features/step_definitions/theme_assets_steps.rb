
Given /^the theme "([^\"]*)" exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |theme_name, site, puid|
  user = User.find_by_puid(puid)
  site = Site.match_domain(site).first
  Factory(:theme_asset, :site => site, :name => theme_name)
end