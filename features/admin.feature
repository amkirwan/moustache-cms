Feature: Test admin page 

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
  When I fill in "user_username" with "foobar" within "div#add_new_user" 
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
  And I follow "edit" within "tr#foobar"
  Then I should now be editing the user "foobar"
  And the "user[username]" field within "div#edit_user" should contain "foobar"
  And the "user[email]" field within "div#edit_user" should contain "foobar@example.com"
  And the "user_role_admin" checkbox within "div#edit_user" should be checked 
  When I fill in "user[username]" with "baz" within "div#edit_user"
  And I fill in "user[email]" with "baz@example.com" within "div#edit_user"
  And I choose "user_role_editor" within "div#edit_user" 
  And I press "Update User" within "div#edit_user" 
  Then I should be on the admin users page
  And I should see "Successfully updated user account for baz"
                                                    