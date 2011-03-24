Feature: show website created in cms

@show_index_page
Scenario: When I go to the index page I should see the root page for the site
  Given the page "index" exists with the layout "application"
  When I go to the root page
  Then I should see "Hello, World!"