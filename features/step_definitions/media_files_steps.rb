def find_media_file(media_file_name)
  MediaFile.where(:name => media_file_name).first
end

Given /^these media files exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, puid, table|
  user = User.find_by_puid(puid)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:media_file, :site => site, :name => hash[:name], :created_by => user, :updated_by => user)
  end
end

Given /^"([^\"]*)" has created the media asset "([^\"]*)"$/ do |puid, asset_name|
  user = User.find_by_puid(puid)
  
  When %{I go to the new admin media file page}
  Given %{I fill in "media_file_name" with "#{asset_name}" within "div#add_new_media_file"}
  Given %{I attach the file "public/images/rails.png" to "media_file_media_asset"}
  Given %{I fill in "media_file_alt_txt" with "#{asset_name}" within "div#add_new_media_file"}  
  Given %{I press "Save Media" within "div#add_new_media_file"}
end

Then /^I should see the url for the file "([^\"]*)"$/ do |media_file_name|
  media_file = find_media_file(media_file_name)
  Then %{I should see "http://#{media_file.site.full_subdomain}#{media_file.media_asset.url}"}
end

Then /^(?:|I )should now be editing the media file "([^\"]*)"$/ do |media_file_name|
  media_file = find_media_file(media_file_name)
  Then %{I should be on the edit admin media file page for "#{media_file.to_param}"} 
end