Feature: Admin User Management Features

@admin_login
Scenario: Admin login page should redirect to /admin/users#index
  Given I login as "ak730" with the role of "admin"
  When I go to the admin page
  Then I should be on the admin users page     

@admin_users_index
Scenario: Admin login
  Given I login as "ak730" with the role of "admin" 
  And the user with the role exist
  | user   | role   |
  | foo    | admin  |
  | bar    | editor |
  | foobar | editor |     
  When I go to the admin users page 
  Then I should be on the admin users page
  And I should see "foo"   
  And I should see "bar"
  And I should see "foobar"    
   
@create_new_user
Scenario: Create A New user
  Given I login as "ak730" with the role of "admin"
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
  Given I login as "ak730" with the role of "admin"
  And the user with the role exist
  | user   | role   |
  | foobar | admin  |
  | bar    | editor |
  When I go to the admin users page
  And I follow "foobar" within "tr#foobar"
  Then I should now be editing the user "foobar"
  And the "user[email]" field within "div#edit_user" should contain "foobar@example.com"
  And the "user_role_admin" checkbox within "div#edit_user" should be checked 
  And I fill in "user[email]" with "baz@example.com" within "div#edit_user"
  And I choose "user_role_editor" within "div#edit_user" 
  And I press "Update User" within "div#edit_user" 
  Then I should be on the admin users page
  And I should see "Successfully updated user account for foobar"
  When I edit the account information for the user "foobar"
  Then I should now be editing the user "foobar"
  And the "user[email]" field within "div#edit_user" should contain "baz@example.com"
  And the "user_role_editor" checkbox within "div#edit_user" should be checked
  
@delete_user
Scenario: Delete user account as an admin
  Given I login as "ak730" with the role of "admin"
  And the user with the role exist
  | user   | role   |
  | foobar | admin  |
  | bar    | editor |
  When I go to the admin users page
  And I press "delete" within "tr#foobar"
  Then I should see "Successfully deleted user account for foobar"
  And I should be on the admin users page
  
@non_admin_edit_account
Scenario: Given I am logged in as an editor then I can edit my account
  Given I login as "ak730" with the role of "editor"
  When I edit the account information for the user "ak730"
  Then I should now be editing the user "ak730"
  And I fill in "user[firstname]" with "Foobar" within "div#edit_user"
  And I fill in "user[lastname]" with "Baz" within "div#edit_user"
  And I fill in "user[email]" with "akirwan@example.com" within "div#edit_user"
  And I should not see "user[role]"
  And I press "Update User" within "div#edit_user" 
  Then I should view the page for user "ak730"
  And I should see "Successfully updated user account for ak730"
  And the "user[firstname]" field within "div#edit_user" should contain "Foobar"
  And the "user[lastname]" field within "div#edit_user" should contain "Baz"
  And the "user[email]" field within "div#edit_user" should contain "akirwan@example.com"

@non_admin_cannot_update_other_users_accounts
Scenario: Given I am logged in as an editor then I cannot edit another users account
  Given I login as "ak730" with the role of "editor"
  And the user with the role exist
  | user   | role   |
  | foobar | admin  |
  | bar    | editor |
  When I edit the account information for the user "bar"
  Then I should see "Whoops!"
  
@non_admin_cannot_see_index_page
Scenario: Given I am logged in as an editor then I cannot list all the users
  Given I login as "ak730" with the role of "editor"
  When I go to the admin users page
  Then I should see "Whoops!"
  
@non_admin_cannot_create_new_user
Scenario: Given I am logged in as an editor then I cannot create a new user
  Given I login as "ak730" with the role of "editor"
  When I go to the new admin user page
  Then I should see "Whoops!"                                                    