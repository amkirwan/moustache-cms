Feature: Admin Layout Management Features

@create_new_layout
Scenario: Create a new layout for the views
  Given I login as "ak730" with the role of "admin"
  And the following layouts exist
  | layout |
  | foobar |
  When I go to the admin layouts page
  Then I should be on the admin layouts page
  And I should see "foobar"
  And I should see "delete"
  And I should see "Add New Layout"
  
