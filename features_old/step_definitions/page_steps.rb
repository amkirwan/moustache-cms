def find_page(page_title)
  page = Page.where(:title => page_title).first
end

def li_id(page)
  "li#" + page.title + "_" + page.id.to_s
end

Given /^these pages exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, username, table|
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
                   :editors => [user],
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

When /^(?:|I )follow "([^\"]*)" associated with "([^\"]*)"$/ do |link, page_title|
  page = find_page(page_title)
  When %{I follow "#{link}" within "#{li_id(page)}"}
end

Then /^(?:|I )should now be editing the page "([^\"]*)"$/ do |page_title|
  page = find_page(page_title)
  Then %{I should be on the edit admin page page for "#{page.to_param}"} 
end

Then /^(?:|I )should see the delete image "([^\"]*)" associated with "([^\"]*)"$/ do |image, item|
  item = find_page(item)
  within("#{li_id(item)}") do
    page.should have_xpath("//a[@data-method=\"delete\"]")
    page.should have_selector("img.delete_image", :alt => "Delete_image", :src => "#{Rails.root}/assets/#{image}")
  end
end

Then /^(?:|I )should not see the delete image "([^\"]*)" associated with "([^\"]*)"$/ do |image, item|
  item = find_page(item)
  within("#{li_id(item)}") do
    page.should_not have_selector("img.delete_image", :alt => "Delete_button", :src => "#{Rails.root}/assets/#{image}")
  end
end

Then /^(?:|I )should see the page "([^\"]*)"$/ do |page_title|
  page = find_page(page_title)
  Then %{I should see "#{page_title}" within "#{li_id(page)}"}
end
