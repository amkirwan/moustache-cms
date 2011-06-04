Feature: Admin Media File Management Features as admin

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |


@admin_index_site_asset
Scenario: Navigate to the Layout#index page
  Given these site assets exist in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | foobar | 
  | bar    |
  When I go to the admin site assets page
  Then I should be on the admin site assets page
  And I should see "foobar"
  And I should see the "delete" button
  And I should see "Add Asset"
  
@admin_should_not_access_other_site 
Scenario: Should not be able to access another sites site assets
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin site assets page
  Then I should see "403"

@create_new_site_asset
Scenario: Create a new media file
  When I go to the admin site assets page
  And I follow "Add Asset" within "ul#new_site_asset"
  And I fill in "site_asset_name" with "foobar" within "div#add_new_site_asset"
  And I fill in "site_asset_description" with "Hello, World!" within "div#add_new_site_asset"
  And I attach the file "spec/fixtures/assets/rails.png" to "site_asset_asset" 
  And I press "Save Asset" within "div#add_new_site_asset"
  Then I should be on the admin site assets page
  And I should see "Successfully created the asset foobar"
  And I should see "foobar"
  And I should see the "delete" button

@edit_site_asset
Scenario: Given I am logged in as an admin then I can edit the site assets I created 
  Given "ak730" has created the site asset "rails"
  When I go to the admin site assets page
  And I follow "rails" within "li#rails"
  Then I should now be editing the site asset "rails"
  And I fill in "site_asset_name" with "foobar" within "div#edit_site_asset"
  And I fill in "site_asset_description" with "New Text" within "div#edit_site_asset"
  And I should see the url for the site asset file "rails"
  And I press "Update Asset" within "div#edit_site_asset"
  Then I should be on the admin site assets page
  And I should see "Successfully updated the asset foobar"
  And I should see "foobar"
  And I should see the "delete" button
  
@edit_site_asset_created_by_another_user
Scenario: Given I am logged in as an admin then I can edit the site assets created by another user
  Given "rg874" has created the site asset "rails"
  When I go to the admin site assets page
  And I follow "rails" within "li#rails"
  Then I should now be editing the site asset "rails"
  And I fill in "site_asset_name" with "foobar" within "div#edit_site_asset" 
  And I press "Update Asset" within "div#edit_site_asset"
  Then I should be on the admin site assets page
  And I should see "Successfully updated the asset foobar"
  
@admin_delete_site_asset
Scenario: Admin can delete site assets
  Given these site assets exist in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | foobar | 
  | bar    |
  When I go to the admin site assets page
  Then I should be on the admin site assets page
  And I press "delete" within "li#foobar"
  And I should see "Successfully deleted the asset foobar"
  And I should be on the admin site assets page
  
@admin_delete_site_asset_created_by_another_user
Scenario: Given I am logged in as an admin then I can delete files created by another user
  Given these site assets exist in the site "foobar.example.com" created by user "rg874"
  | name   | 
  | foobar | 
  | bar    |
  When I go to the admin site assets page
  Then I should be on the admin site assets page
  And I press "delete" within "li#foobar"
  And I should see "Successfully deleted the asset foobar"
  And I should be on the admin site assets page
