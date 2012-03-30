Feature: Login User

  Scenario: Login to admin page
    Given I go to the admin login page
    When I login as an admin
    Then I should see "Signed in successfully"
