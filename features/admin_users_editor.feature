Feature: Admin User Management Features as user with editor role

Background: Create Site
  Given the site "foobar" exists with the domain "example.com"
  Given the user "ak730" exists with the role of "editor" in the site "foobar.example.com"
  And I authenticates as cas user "ak730"

# Actions Passing
  
@editor_can_see_index_page
Scenario: Given I am logged in as an editor then I cannot list all the users
  Given the user with the role exist
  | user   | role   | site               |
  | foo    | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  When I go to the admin users page
  Then I should be on the admin users page
  And I should see "foo"   
  And I should see "bar"
  
@editor_edit_own_account
Scenario: Given I am logged in as an editor then I can edit my account
  When I edit the account information for the user "ak730"
  Then I should now be editing the user "ak730"
  And I fill in "user[firstname]" with "Foobar" 
  And I fill in "user[lastname]" with "Baz" 
  And I fill in "user[email]" with "akirwan@example.com" 
  And I should not see "user[role]"
  And I press "Update User" within "div#edit_user" 
  Then I should be on the admin users page
  And I should see "Successfully updated user account for ak730"
  When I edit the account information for the user "ak730"
  And the "user[firstname]" field should contain "Foobar"
  And the "user[lastname]" field should contain "Baz"
  And the "user[email]" field should contain "akirwan@example.com"


@editor_can_delete_own_account
Scenario: Given I am logged in as an editor then I can delete my account
  When I go to the admin users page
  And I press "delete" within "li#ak730"
  Then I should be on the cms html page

# Actions_Blocked   
  
@editor_should_not_access_other_site 
Scenario: Should not be able to access site the user is not associated with
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin users page
  Then I should see "403"
  
@editor_cannot_create_new_user
Scenario: Editor cannot create new users
  When I go to the new admin user page
  Then I should see "403"

@editor_cannot_update_other_users_accounts
Scenario: Given I am logged in as an editor then I cannot edit another users account
  Given the user with the role exist
  | user   | role   | site               |
  | foo    | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  When I edit the account information for the user "bar"
  Then I should see "403"
  
@editor_cannot_delete_other_users_accounts
Scenario: Given I am logged in as an editor then I cannot edit another users account
  Given the user with the role exist
  | user   | role   | site               |
  | foo    | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  When I go to the admin users page
  Then I should not see the "delete" button in "li#foo"
  And I should not see the "delete" button in "li#bar"