Feature: Admin User Management Features as user with admin role

Background: Login create default site
  Given the site "foobar" exists with the domain "example.com"
  And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
  And I authenticates as cas user "ak730"

@admin_login
Scenario: Admin login page should redirect to /admin/users#index
  When I go to the admin page
  Then I should be on the admin pages page 

@admin_should_not_access_other_site 
Scenario: Should not be able to access site the user is not associated with
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin page
  Then I should see "403"
  
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
  | user   | role   | site               |
  | foo    | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  When I go to the admin users page
  And I follow "foo" within "li#foo"
  Then I should now be editing the user "foo"
  And the "user[email]" field should contain "foo@example.com"
  And the "user_role_admin" checkbox should be checked 
  And I fill in "user[email]" with "baz@example.com" 
  Then I choose "user_role_editor" 
  And I press "Update User" within "div#edit_user" 
  Then I should be on the admin users page
  And I should see "Successfully updated user account for foo"
  When I edit the account information for the user "foo"
  Then I should now be editing the user "foo"
  And the "user[email]" field should contain "baz@example.com"
  And the "user_role_editor" checkbox should be checked
  
@delete_user
Scenario: Delete user account as an admin
  And the user with the role exist
  | user   | role   | site               |
  | foobar | admin  | foobar.example.com |
  | bar    | editor | foobar.example.com |
  When I go to the admin users page
  And I press "delete" within "li#foobar"
  Then I should see "Successfully deleted user account for foobar"
  And I should be on the admin users page
                                                   