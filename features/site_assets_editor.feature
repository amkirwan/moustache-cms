Feature: Admin Site Assets Management Features as editor

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "editor" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |
And these collections exist in the site "foobar.example.com" created by user "ak730"
| name   | 
| foobar | 
| bar    |


@editor_index_site_asset
Scenario: Navigate to the SiteAsset#index page
  Given these site assets exist in the collection "foobar" in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | baz    | 
  | qux    |
  When I view the collection "foobar" admin asset collection site assets page
  Then navigate to the admin asset collection site assets page for "foobar" 
  And I should see "baz"
  And I should see "qux"
  
@edit_site_asset
Scenario: Given I am logged in as an editor then I can edit the site assets I created
  Given "ak730" has created the site asset "rails" in the collection "foobar"
  When I view the collection "foobar" admin asset collection site assets page
  And I follow "rails" 
  Then I should now be editing the site asset "rails" in the collection "foobar"
  And I fill in "site_asset_name" with "foobar" 
  And I fill in "site_asset_description" with "New Text" 
  And I should see the filename of the site asset
  And I press "Update Asset" 
  And I should see "Successfully updated the asset foobar"
  And I should see "foobar"

@edit_site_asset_created_by_another_user
Scenario: Given I am logged in as an editor then I can edit the site assets created by another user
  Given "rg874" has created the site asset "rails" in the collection "foobar" 
  When I view the collection "foobar" admin asset collection site assets page 
  And I follow "rails"
  And I fill in "site_asset_name" with "foobar"
  And I press "Update Asset" 
  And I should see "Successfully updated the asset foobar"  

@editor_delete_site_asset
Scenario: editor can delete site assets
  Given these site assets exist in the collection "foobar" in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | baz    | 
  | qux    |
  When I view the collection "foobar" admin asset collection site assets page
  Then navigate to the admin asset collection site assets page for "foobar"  
  When I follow "baz" 
  Then I should now be editing the site asset "baz" in the collection "foobar"
  And I follow "Delete Asset"
  Then I should see "Successfully deleted the asset baz"
  And I should view the collection "foobar" admin asset collection site assets page


@editor_delete_site_asset_created_by_another_user
Scenario: Given I am logged in as an editor then I can delete files created by another user
  Given these site assets exist in the collection "foobar" in the site "foobar.example.com" created by user "rg874"
  | name   | 
  | bar    |
  When I view the collection "foobar" admin asset collection site assets page
  Then navigate to the admin asset collection site assets page for "foobar"


