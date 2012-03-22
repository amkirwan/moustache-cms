Feature: Login User

Background: Create default site
  Given the site "foobar" exists with the domain "example.com"
  And the user "amkirwan" exists with the role of "admin" in the site "foobar.example.com"

  @login
  Scenario: Login to admin page
    Given I go to the admin login page
    When I login as an admin
    Then I should see the flash message "Signed in successfully"

  @prevent_login
  Scenario: Login failure 
    Given I go to the admin login page
    When I try to login as a user that does not exist
    Then I should see the flash message "Invalid email or password"
