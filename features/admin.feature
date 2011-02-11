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
  When I go to the admin page
  Then I should be on the admin users page
  And I should see "foo"   
  And I should see "bar"
  And I should see "foobar"
  