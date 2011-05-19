Feature: Admin Media File Management Features as editor

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "editor" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |


@editor_index_media_file
Scenario: Navigate to the MediaFile#index page
  Given these media files exist in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | foobar | 
  | bar    |
  When I go to the admin media files page
  Then I should be on the admin media files page
  And I should see "foobar"
  And I should see the "delete" button
  And I should see "Add Media File"
  
@editor_new_media_file
Scenario: Editor can create a new media file
  When I go to the admin media files page
  And I follow "Add Media File" within "ul#new_media_file"
  And I fill in "media_file_name" with "foobar" within "div#add_new_media_file"
  And I fill in "media_file_description" with "Hello, World!" within "div#add_new_media_file"
  And I attach the file "public/images/rails.png" to "media_file_media_asset"
  And I fill in "media_file_alt_txt" with "foobar" within "div#add_new_media_file"  
  And I press "Save Media" within "div#add_new_media_file"
  Then I should be on the admin media files page
  And I should see "Successfully created the media file foobar"
  And I should see "foobar"
  And I should see the "delete" button
  
@editor_edit_media_file
Scenario: Given I am logged in as an editor then I can edit the media files I created 
  Given "ak730" has created the media asset "rails"
  When I go to the admin media files page
  And I follow "rails" within "li#rails"
  Then I should now be editing the media file "rails"
  And I fill in "media_file_name" with "foobar" within "div#edit_media_file"
  And I fill in "media_file_description" with "New Text" within "div#edit_media_file"
  And I should see the url for the file "rails"
  And I fill in "media_file_alt_txt" with "other alt text" within "div#edit_media_file"  
  And I press "Update Media File" within "div#edit_media_file"
  Then I should be on the admin media files page
  And I should see "Successfully updated the media file foobar"
  And I should see "foobar"
  And I should see the "delete" button
  
@editor_delete_media_file
Scenario: Given I am logged in as an editor then I can delete media files I created
  Given these media files exist in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | foobar | 
  | bar    |
  When I go to the admin media files page
  Then I should be on the admin media files page
  And I press "delete" within "li#foobar"
  And I should see "Successfully deleted the media file foobar"
  And I should be on the admin media files page
  
# Actions_Blocked 

@editor_should_not_access_other_site 
Scenario: Should not be able to access another sites media files
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin media files page
  Then I should see "403"
  
@editor_cannot_delete_media_file_not_created
Scenario: Given I am logged in as an editor then I can delete media files I created
  Given these media files exist in the site "foobar.example.com" created by user "jmb42"
  | name   | 
  | foobar | 
  | bar    |
  When I go to the admin media files page
  Then I should be on the admin media files page
  And I should not see the "delete" button in "li#foobar"
  And I should not see the "delete" button in "li#bar"

