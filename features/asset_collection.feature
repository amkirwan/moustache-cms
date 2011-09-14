Feature: Admin Asset Collections

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |  
 
@index_asset_collection
Scenario: Navigate to the AssetCollection#index page
 Given these collections exist in the site "foobar.example.com" created by user "ak730"
 | name   | 
 | foobar | 
 | bar    |
 When I go to the admin asset collections page
 Then I should be on the admin asset collections page
 And I should see "foobar"
 And I should see "Delete"
 And I should see "New Asset Collection"    
 
@other_site_denied_asset_collection
Scenario: Should not be able to access another sites asset_collections the admin is not associated with
 Given the site "baz" exists with the domain "example.dev"
 When I go to the admin asset collections page
 Then I should see "403"    
 

@show_asset_collection
Scenario: Navigate to the AssetCollection#show page
  Given these collections exist in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | foobar | 
  | bar    |   
  When I view the collection "foobar"
  Then I should see "Actions"
  And I should see "New Asset"
  And I should see "Edit Collection Prop"
  And I should see "Delete Collection"     
  
@create_asset_collection
Scenario: New Asset Collection
  When I go to the admin asset collections page
  And I follow "New Asset Collection"
  And I fill in "asset_collection_name" with "foobar"
  And I press "Save Collection"
  Then I should be on the admin asset collections page
  And I should see "Successfully created the asset collection foobar"
  And I should see "foobar"   
  
@update_asset_collection
Scenario: Update Asset Collection Properties
  Given these collections exist in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | foobar | 
  | bar    | 
  When I go to the admin asset collections page 
  And I view the collection "foobar"
  And I follow "Edit Collection Prop"
  Then I should now be editing the asset collection "foobar"
  When I fill in "asset_collection_name" with "baz"
  And I press "Update Collection"
  Then I should be viewing the collection "baz"
  And I should see "Successfully updated the asset collection baz"
  And I should see "baz"
  
@delete_asset_collection
Scenario: Delete Asset Collection
  Given these collections exist in the site "foobar.example.com" created by user "ak730"
  | name   | 
  | foobar | 
  | bar    |   
  When I go to the admin asset collections page 
  And I view the collection "foobar"
  And I follow "Delete Collection"
  Then I should see "Successfully deleted the asset collection foobar"
  And I should be on the admin asset collections page    
 
  
