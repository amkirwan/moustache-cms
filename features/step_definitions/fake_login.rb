Given /^I authenticates as cas user "([^\"]*)"$/ do |puid|
  CASClient::Frameworks::Rails::Filter.fake(puid)  
end 

Given /^the user "([^\"]*)" exists with the role of "([^\"]*)" in the site "([^\"]*)"$/ do |puid, role, site| 
  user = Factory(:user, :puid => puid,
                 :email => "#{puid}@example.com",
                 :role => role,
                 :site => Site.match_domain(site).first)
end

Given /^the site "([^\"]*)" exists with the domain "([^\"]*)"$/ do |site, domain|
  Factory(:site, :name => site, :subdomain => site, :default_domain => domain)
  Capybara.default_host = "#{site}.#{domain}"
end

Given /^I login to the site "([^\"]*)" as "([^\"]*)" with the role of "([^\"]*)"$/ do |site, puid, role|
  Given %{the user "#{puid}" exists with the role of "#{role}" in the site "#{site}"}
  Given %{cas authenticates with cas user "#{puid}"}
end   

Given /^the user with the role exist$/ do |table|
  table.hashes.each do |hash|
    Given %{the user "#{hash[:user]}" exists with the role of "#{hash[:role]}" in the site "#{hash[:site]}"}
  end
end 

When /^I want to go to the site "([^\"]*)"$/ do |site|
 Capybara.default_host = "#{site}.example.com"
end