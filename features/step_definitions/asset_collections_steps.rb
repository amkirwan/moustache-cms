Given /^these collections exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, puid, table|
  user = User.find_by_puid(puid)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:asset_collection, :site => site, :name => hash[:name], :created_by => user, :updated_by => user)
  end
end