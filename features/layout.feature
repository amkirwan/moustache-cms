@create_new_layout
Scenario: Create a new layout for the views
  Given I login as "ak730" with the role of "admin"
  When I go to the admin users page
  And I follow "New User" within "ul#new_user"
  Then I should be on the new admin user page 
  When I fill in "user_puid" with "foobar" within "div#add_new_user"
  When I fill in "user_username" with "foobar" within "div#add_new_user" 
  And I fill in "user_email" with "foobar@example.com" within "div#add_new_user"
  And I choose "user_role_admin" within "div#add_new_user"
  And I press "Create User" within "div#add_new_user"
  Then I should be on the admin users page 
  And I should see "Successfully created user account for foobar"
  And I should see "foobar"
  And I should see "admin"