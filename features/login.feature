Feature: Login User

Background: Create default site
  Given the site "foobar" exists with the domain "example.com"
  And the user "amkirwan" exists with the role of "admin" in the site "foobar.example.com"

  Scenario: Login to admin page
    Given I go to the admin login page
    When I login as an admin
    Then I should see "Signed in successfully"
