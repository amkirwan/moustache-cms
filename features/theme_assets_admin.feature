Feature: Admin Theme Asset Management Features as admin

Background: Login create default theme
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |


@admin_index_theme_asset
Scenario: Navigate to the Layout#index page
  Given these theme assets exist in the site "foobar.example.com" created by user "ak730"
   | name      | file          | 
   | theme_css | theme_css.css | 
   | theme_js  | theme_js.js   | 
   | rails     | rails.png     | 
  When I go to the admin theme assets page
  Then I should be on the admin theme assets page
  And I should see "theme_css"
  And I should see "theme_js"
  And I should see "rails"
  And I should see "Add Theme Asset"
  
@admin_should_not_access_other_sites_themes 
Scenario: Should not be able to access another sites theme assets
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin theme assets page
  Then I should see "403"
  
@create_new_theme_asset
Scenario: Create a new media file
  When I go to the admin theme assets page
  And I follow "Add Theme Asset" within "ul#new_theme_asset"
  And I fill in "theme_asset_name" with "foobar" within "div#add_new_theme_asset"
  And I fill in "theme_asset_description" with "Hello, World!" within "div#add_new_theme_asset"
  And I attach the file "spec/fixtures/assets/rails.png" to "theme_asset_asset" 
  And I press "Save Theme Asset" within "div#add_new_theme_asset"
  Then I should be on the admin theme assets page
  And I should see "Successfully created the theme asset foobar"
  And I should see "foobar"
  And I should see the "delete" button
  
@edit_theme_asset
Scenario: Given I am logged in as an admin then I can edit the theme assets I created 
  Given "ak730" has created the theme asset "rails"
  When I go to the admin theme assets page
  And I follow "rails" within "li#rails"
  Then I should now be editing the theme asset "rails"
  And I fill in "theme_asset_name" with "foobar" within "div#edit_theme_asset"
  And I fill in "theme_asset_description" with "New Text" within "div#edit_theme_asset"
  And I should see the url for the theme asset file "rails"
  And I press "Update Theme Asset" within "div#edit_theme_asset"
  Then I should be on the admin theme assets page
  And I should see "Successfully updated the theme asset foobar"
  And I should see "foobar"
  And I should see the "delete" button  
  
  
@edit_theme_asset_created_by_another_user
Scenario: Given I am logged in as an admin then I can edit the theme assets created by another user
  Given "rg874" has created the theme asset "rails"
  When I go to the admin theme assets page
  And I follow "rails" within "li#rails"
  Then I should now be editing the theme asset "rails"
  And I fill in "theme_asset_name" with "foobar" within "div#edit_theme_asset" 
  And I press "Update Theme Asset" within "div#edit_theme_asset"
  Then I should be on the admin theme assets page
  And I should see "Successfully updated the theme asset foobar" 
  

@admin_delete_theme_asset
Scenario: Admin can delete theme assets
  Given these theme assets exist in the site "foobar.example.com" created by user "ak730"
  | name      | file          | 
  | theme_css | theme_css.css | 
  | theme_js  | theme_js.js   | 
  | rails     | rails.png     |
  When I go to the admin theme assets page
  Then I should be on the admin theme assets page
  And I press "delete" within "li#theme_css"
  And I should see "Successfully deleted the theme asset theme_css"
  And I should be on the admin theme assets page                  
  
@admin_delete_theme_asset_created_by_another_user
Scenario: Given I am logged in as an admin then I can delete files created by another user
  Given these theme assets exist in the site "foobar.example.com" created by user "ak730" 
  | name      | file          | 
  | theme_css | theme_css.css | 
  | theme_js  | theme_js.js   | 
  | rails     | rails.png     |
  When I go to the admin theme assets page
  Then I should be on the admin theme assets page
  And I press "delete" within "li#theme_css"
  And I should see "Successfully deleted the theme asset theme_css"
  And I should be on the admin theme assets page  