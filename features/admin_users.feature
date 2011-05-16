Feature: Admin User Management Features

Background: Login create default site
  Given the site "foobar" exists
  And the user "ak730" exists with the role of "admin" in the site "foobar"
  And cas authenticates with cas user "ak730"

@admin_login
Scenario: Admin login page should redirect to /admin/users#index
  When I go to the admin page
  Then I should be on the admin pages page 

@admin_should_not_login    
Scenario: Should not be able to access site the user is not associated with
  Given the site "baz" exists
  When I go to the admin page
  Then I should see "Whoops!"
  
@admin_users_index
Scenario: Admin login
  And the user with the role exist
  | user   | role   | site               |
  | foo    | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  | foobar | editor | foobar.example.com |
  When I go to the admin users page 
  Then I should be on the admin users page
  And I should see "foo"   
  And I should see "bar"
  And I should see "foobar"    
   
@create_new_user
Scenario: Create A New user
  When I go to the admin users page
  And I follow "New User" within "ul#new_user"
  Then I should be on the new admin user page 
  When I fill in "user_puid" with "foobar" within "div#add_new_user"
  And I fill in "user_email" with "foobar@example.com" within "div#add_new_user"
  And I choose "user_role_admin" within "div#add_new_user"
  And I press "Create User" within "div#add_new_user"
  Then I should be on the admin users page 
  And I should see "Successfully created user account for foobar"
  And I should see "foobar"
  And I should see "admin"  
  
@edit_user
Scenario: Given I am logged in as an admin then I can edit any users account
  And the user with the role exist
  | user   | role   |
  | foobar | admin  |
  | bar    | editor |
  When I go to the admin users page
  And I follow "foobar" within "li#foobar"
  Then I should now be editing the user "foobar"
  And the "user[email]" field should contain "foobar@example.com"
  And the "user_role_admin" checkbox should be checked 
  And I fill in "user[email]" with "baz@example.com" 
  Then I choose "user_role_editor" 
  And I press "Update User" within "div#edit_user" 
  Then I should be on the admin users page
  And I should see "Successfully updated user account for foobar"
  When I edit the account information for the user "foobar"
  Then I should now be editing the user "foobar"
  And the "user[email]" field should contain "baz@example.com"
  And the "user_role_editor" checkbox should be checked
  
@delete_user
Scenario: Delete user account as an admin
  And the user with the role exist
  | user   | role   |
  | foobar | admin  |
  | bar    | editor |
  When I go to the admin users page
  And I press "delete" within "li#foobar"
  Then I should see "Successfully deleted user account for foobar"
  And I should be on the admin users page
  
@non_admin_edit_account
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

@non_admin_cannot_update_other_users_accounts
Scenario: Given I am logged in as an editor then I cannot edit another users account
  Given I login as "cds27" with the role of "editor"
  And the user with the role exist
  | user   | role   |
  | foobar | admin  |
  | bar    | editor |
  When I edit the account information for the user "bar"
  Then I should see "Whoops!"
  
@non_admin_cannot_see_index_page
Scenario: Given I am logged in as an editor then I cannot list all the users
  Given I login as "cds27" with the role of "editor"
  When I go to the admin users page
  Then I should see "Whoops!"
  
@non_admin_cannot_create_new_user
Scenario: Given I am logged in as an editor then I cannot create a new user
  Given I login as "cds27" with the role of "editor"
  When I go to the new admin user page
  Then I should see "Whoops!"                                                    