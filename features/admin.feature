Feature: Test admin page


@admin_login
Scenario: Admin login page
  Given I am not authenticated
  When I go to the admin page
  Then I should be on the admin login page     

@admin_login_index
Scenario: Admin login
  Given I login as "akirwan" with role "admin" 
  And the user with role
  | user   | role   |
  | foo    | admin  |
  | bar    | editor |
  | foobar | editor |
  Then I should be on the admin users page 
  