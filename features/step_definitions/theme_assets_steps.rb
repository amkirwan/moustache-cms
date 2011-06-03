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

Given /^these theme assets exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, puid, table|
  user = User.find_by_puid(puid)
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