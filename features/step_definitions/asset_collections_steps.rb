def find_collection(collection_name)
  AssetCollection.where(:name => collection_name).first
end

Given /^these collections exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, username, table|
  site = Site.match_domain(site).first
  user = User.where(:username => username, :site_id => site.id).first
  table.hashes.each do |hash|
    Factory(:asset_collection, :site_id => site.id, :name => hash[:name], :created_by => user, :updated_by => user)
  end
end    

When /^(?:|I )view the collection "([^\"]*)"$/ do |collection_name|
  collection = find_collection(collection_name)
  When %{I go to the admin asset collection page for "#{collection.to_param}"}
end                                             

Then /^(?:|I )should now be editing the asset collection "([^\"]*)"$/ do |collection_name|
  collection = find_collection(collection_name)
  Then %{I should be on the edit admin asset collection page for "#{collection.to_param}"} 
end           

Then /^(?:|I )should be viewing the collection "([^\"]*)"$/ do |collection_name|
  collection = find_collection(collection_name)     
  Then %{I should be on the admin asset collection page for "#{collection.to_param}"}
end
