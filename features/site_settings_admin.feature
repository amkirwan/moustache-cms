Feature: Admin User Management Features as user with admin role

Background: Login create default site
  Given the site "foobar" exists with the domain "example.com"
  And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
  And I authenticates as cas user "ak730"


@admin_site_settings_edit
  Scenario: Givin I am logged in as admin then I can edit the site settings
    When I edit the current site "foobar"
    Then I should now be editing the current site "foobar"
    And I fill in "site[subdomain]" with "foobar" 
