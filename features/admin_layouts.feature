Feature: Admin Layout Management Features

Background: Login create default site
Given I login as "ak730" with the role of "admin"
And the site "foobar" exists

@index_layout
Scenario: Navigate to the Layout#index page
  Given these layouts exist in the site "foobar" created by user "ak730"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  Then I should be on the admin layouts page
  And I should see "foobar"
  And I should see the "delete" button
  And I should see "Add New Layout"
  
@create_new_layout
Scenario: Create a New Layout
  When I go to the admin layouts page
  And I follow "Add New Layout" within "ul#new_layout"
  And I fill in "layout_name" with "foobar" within "div#add_new_layout"
  And I fill in "layout_content" with "Hello, World!" within "div#add_new_layout"
  And I press "Create Layout" within "div#add_new_layout"
  Then I should be on the admin layouts page
  And I should see "Successfully created the layout foobar"
  And I should see "foobar"
  And I should see the "delete" button

@edit_layout
Scenario: Given I am logged in as an admin then I can edit a layout
  Given these layouts exist in the site "foobar" created by user "ak730"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  And I follow "foobar" within "tr#foobar"
  Then I should now be editing the layout "foobar"
  And the "layout[name]" field should contain "foobar"
  And the "layout[content]" field should contain "Hello, World!"
  When I fill in "layout[name]" with "baz" within "div#edit_layout"
  And I fill in "layout[content]" with "Hello, <b>World!</b>" within "div#edit_layout"
  And I press "Update Layout" within "div#edit_layout"
  Then I should be on the admin layouts page
  And I should see "Successfully updated the layout baz"
  When I edit the layout "baz"
  Then I should now be editing the layout "baz"
  And the "layout[name]" field should contain "baz"
  And the "layout[content]" field should contain "Hello, <b>World!</b>"
  
@delete_layout
Scenario: Delete layout as an admin
  Given these layouts exist in the site "foobar" created by user "ak730"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  And I press "delete" within "tr#foobar"
  Then I should see "Successfully deleted the layout foobar"
  And I should be on the admin layouts page
