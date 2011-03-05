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
  And I should see "Add New Layout"
  
@create_new_layout
Scenario: Create a New Layout
  Given I login as "ak730" with the role of "admin"
  When I go to the admin layouts page
  And I follow "Add New Layout" within "ul#new_layout"
  When I fill in "layout_name" with "foobar" within "div#add_new_layout"
  And I fill in "layout_content" with "Hello, World!" within "div#add_new_layout"
  And I press "Create Layout" within "div#add_new_layout"
  Then I should be on the admin layouts page
  And I should see "Successfully created layout foobar"
  And I should see "foobar"
  And I should see "delete" button
 