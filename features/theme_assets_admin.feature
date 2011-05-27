Feature: Admin Theme Asset Management Features as admin

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |


@admin_index_theme_asset
Scenario: Navigate to the Layout#index page
  Given these theme assets exist in the site "foobar.example.com" created by user "ak730"
   | name      | file          |
   | theme_css | theme_css.css |
   | theme_js  | theme_js.js   |
   | rails     | rails.png     |
  When I go to the admin theme assets page
  Then I should be on the admin theme assets page
  And I should see "theme_css"
  And I should see "theme_js"
  And I should see "rails"
  And I should see "Add Asset"