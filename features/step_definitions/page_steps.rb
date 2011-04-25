Given /^these pages exist in the site "([^\"]*)" with the user "([^\"]*)"$/ do |site, username, table|
  user = User.find_by_username(username)
  site = Site.match_domain(site).first
  layout = Factory(:layout, :site => site, :created_by => user, :updated_by => user)
  parent = Factory(:page, :site => site, :layout => layout, :created_by => user, :updated_by => user)
  table.hashes.each do |hash|
    Factory(:page, :site => site,
                   :parent => parent, 
                   :layout => layout,
                   :created_by => user,
                   :updated_by => user,
                   :title => hash[:title], 
                   :current_state => Factory.build(:current_state, :name => hash[:status]))
  end
end

Given /^these current states exist$/ do  |table|
  table.hashes.each do |hash|
    Factory.build(:current_state, :name => hash[:name])
  end
end