Feature: Admin Theme Asset Management Features as admin

Background: Login create default theme
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I login as the user "ak730" to the site "foobar.example.com"
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
  And I should see "theme_css" within "div#css_files"
  And I should see "Delete" within "div#css_files"
  And I should see "theme_js" within "div#js_files"
  And I should see "Delete" within "div#js_files"
  And I should see "rails" within "div#image_files"
  And I should see "Delete" within "div#image_files"
  And I should see "New Theme Asset"
  
@admin_should_not_access_other_sites_themes 
Scenario: Should not be able to access another sites theme assets
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin theme assets page
  Then I should be on the new admin user session page
  
@create_new_theme_asset
Scenario: Create a new media file
  When I go to the admin theme assets page
  And I follow "New Theme Asset" 
  And I fill in "theme_asset_name" with "foobar" 
  And I fill in "theme_asset_description" with "Hello, World!" 
  And I attach the file "spec/fixtures/assets/rails.png" to "theme_asset_asset" 
  And I press "Save Theme Asset" 
  Then I should be on the admin theme assets page
  And I should see "Successfully created the theme asset foobar"
  And I should see "foobar"
  And I should see "Delete"
  
@edit_theme_asset
Scenario: Given I am logged in as an admin then I can edit the theme assets I created 
  Given "ak730" has created the theme asset "rails"
  When I go to the admin theme assets page
  And I follow "rails" 
  Then I should now be editing the theme asset "rails"
  And I fill in "theme_asset_name" with "foobar" 
  And I fill in "theme_asset_description" with "New Text" 
  And I press "Update Theme Asset" 
  Then I should be on the admin theme assets page
  And I should see "Successfully updated the theme asset foobar"
  And I should see "foobar"
  And I should see "Delete"  
  
  
@edit_theme_asset_created_by_another_user
Scenario: Given I am logged in as an admin then I can edit the theme assets created by another user
  Given "rg874" has created the theme asset "rails"
  When I go to the admin theme assets page
  And I follow "rails" 
  Then I should now be editing the theme asset "rails"
  And I fill in "theme_asset_name" with "foobar" 
  And I press "Update Theme Asset" 
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
  And I follow "Delete" within "tr#theme_css_css"
  And I should see "Successfully deleted the theme asset theme_css"
  And I should be on the admin theme assets page  
  
@admin_delete_theme_asset_editing
Scenario: Admin can delete theme assets while editing
  Given "rg874" has created the theme asset "rails"
  When I go to the admin theme assets page
  And I follow "rails" 
  Then I should now be editing the theme asset "rails"
  And I follow "Delete Theme Asset"
  And I should see "Successfully deleted the theme asset rails"
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
  And I follow "Delete" 
  And I should see "Successfully deleted the theme asset theme_css"
  And I should be on the admin theme assets page  
