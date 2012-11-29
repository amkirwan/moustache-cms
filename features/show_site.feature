Feature: show website created in cms

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"

@show_homepage
Scenario: When I go to the index page I should see the root page for the site
  Given the Homepage exists in the site "foobar.example.com"
  When I go to the sites homepage
  Then I should see the homepage

