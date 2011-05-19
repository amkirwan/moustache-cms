Feature: show website created in cms

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"

@show_index_page
Scenario: When I go to the index page I should see the root page for the site
  Given the page "Home Page" exists with the layout "application" in the site "foobar.example.com"
  When I go to the home page
  Then I should see "Hello, World!"