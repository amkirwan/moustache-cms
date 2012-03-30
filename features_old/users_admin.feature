Feature: Admin User Management Features as user with admin role

Background: Login create default site
  Given the site "foobar" exists with the domain "example.com"
  And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
  And I login as the user "ak730" to the site "foobar.example.com"

@admin_users_index
Scenario: Admin login
  Given the user with the role exist
  | user   | role   | site               |
  | foo    | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  | foobar | editor | foobar.example.com |
  When I go to the admin users page 
  Then I should be on the admin users page
  And I should see "Anthony Kirwan" within "tr#foo"
  And I should see "foo" within "tr#foo"
  And I should see "Admin" within "tr#foo"
  And I should see "Anthony Kirwan" within "tr#bar"
  And I should see "bar" within "tr#bar" 
  And I should see "Editor" within "tr#bar" 
  And I should see "Anthony Kirwan" within "tr#foobar"
  And I should see "foobar" within "tr#foobar" 
  And I should see "Editor" within "tr#foobar" 

@create_new_user
Scenario: Create A New user
  When I go to the admin users page
  And I follow "New User" 
  Then I should be on the new admin user page 
  When I fill in "user_username" with "foobar" 
  And I fill in "user_firstname" with "Anthony "
  And I fill in "user_lastname" with "Kirwan"
  And I fill in "user_email" with "foobar@example.com" 
  And I choose "user_role_admin" 
  And I press "Create User" 
  Then I should be on the admin users page 
  And I should see "Successfully created user profile for Anthony Kirwan"

@admin_edit_own_account
Scenario: Given I am logged in as an admin then I can edit my account
  When I go to the admin users page
  And I follow "Anthony Kirwan" within "tr#ak730"
  Then I should now be editing the user "ak730"
  And I fill in "user[firstname]" with "Foobar" 
  And I fill in "user[lastname]" with "Baz" 
  And I fill in "user[email]" with "akirwan@example.com" 
  And I should not see "user[role]"
  And I press "Update User" 
  Then I should be on the admin users page
  And I should see "Successfully updated user profile for Foobar Baz"
  When I edit the account information for the user "ak730"
  And the "user[firstname]" field should contain "Foobar"
  And the "user[lastname]" field should contain "Baz"
  And the "user[email]" field should contain "akirwan@example.com" 
  
@admin_edit_user_other_user_account
Scenario: Given I am logged in as an admin then I can edit any users account
  Given the user with the role exist
  | user   | role   | site               |
  | foo    | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  When I go to the admin users page
  And I follow "Anthony Kirwan" within "tr#foo"
  Then I should now be editing the user "foo"
  And the "user[email]" field should contain "foo@example.com"
  And the "user_role_admin" checkbox should be checked 
  And I fill in "user[email]" with "baz@example.com" 
  Then I choose "user_role_editor" 
  And I press "Update User" 
  Then I should be on the admin users page
  And I should see "Successfully updated user profile for Anthony Kirwan"
  When I edit the account information for the user "foo"
  Then I should now be editing the user "foo"
  And the "user[email]" field should contain "baz@example.com"
  And the "user_role_editor" checkbox should be checked
  
@admin_can_delete_own_account
Scenario: Given I am logged in as an admin then I can delete my account
  When I go to the admin users page
  And I follow "Delete" within "tr#ak730"
  Then I should be on the new admin user session page
  
@admin_can_delete_own_account_from_page
Scenario: Given I am logged in as an admin then I can delete my account from my user page
  When I go to the admin users page
  And I follow "Anthony Kirwan" within "tr#ak730"
  Then I should now be editing the user "ak730"
  When I follow "Delete User" 
  Then I should be on the new admin user session page
  
@admin_delete_other_user_account
Scenario: Delete user account as an admin
  Given the user with the role exist
  | user   | role   | site               |
  | foobar | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  When I go to the admin users page
  And I follow "Delete" within "tr#foobar"
  Then I should see "Successfully deleted user profile for Anthony Kirwan"
  And I should be on the admin users page
                                                   
