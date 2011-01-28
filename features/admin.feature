Feature: Test admin page


@login_page
Scenario: Admin login page

  Given I am "ak730"
  When I go to the admin login page
  Then I should be on the admin login page