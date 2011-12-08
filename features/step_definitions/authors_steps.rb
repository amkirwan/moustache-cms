Given /^these authors exists in the site "([^"]*)"$/ do |site, table|
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:author, :firstname => hash[:firstname], :middlename => hash[:middlename], :lastname => hash[:lastname], :profile => hash[:profile], :site => site)
  end
end

When /^I view the authors page$/ do
  visit admin_authors_path
end

Then /^I should see the authors$/ do |table|
  table.hashes.each do |hash|
    if hash[:middlename].empty?
      name = hash[:firstname] + ' ' + hash[:lastname]
    else
      name = hash[:firstname] + ' ' + hash[:middlename] + ' ' + hash[:lastname]
    end
    page.should have_content name
  end
end
