def find_page(page_title)
  page = Page.where(:title => page_title).first
end

Given /^these pages exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, puid, table|
  user = User.find_by_puid(puid)
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

When /^(?:|I )edit the page "([^\"]*)"$/ do |page_title|
  page = find_page(page_title)
  When %{I go to the edit admin page page for "#{page.to_param}"}
end

Then /^(?:|I )should now be editing the page "([^\"]*)"$/ do |page_title|
  page = find_page(page_title)
  Then %{I should be on the edit admin page page for "#{page.to_param}"} 
end