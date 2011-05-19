Feature: Theme Assets Features as Admin user

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I authenticates as cas user "ak730"

@admin_theme_assets_index
Scenario: Navigate to the Theme Management
  Given the theme "foobar" exist in the site "foobar.example.com" created by user "ak730"
  When I go to the admin theme assets page
  Then I should be on the admin theme assets page
  And I should see "foobar"
  And I should see the "delete" button
  And I should see "Add new file"