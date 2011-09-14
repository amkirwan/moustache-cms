Feature: Admin Layout Management Features as Admin user

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |

@admin_index_layout
Scenario: Navigate to the Layout#index page
  Given these layouts exist in the site "foobar.example.com" created by user "ak730"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  Then I should be on the admin layouts page
  And I should see "foobar"
  And I should see "Delete"
  And I should see "New Layout"

@admin_should_not_access_other_site 
Scenario: Should not be able to access another sites layout the admin is not associated with
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin layouts page
  Then I should see "403"
  
@create_new_layout
Scenario: Create a New Layout
  When I go to the admin layouts page
  And I follow "New Layout" 
  And I fill in "layout_name" with "foobar" 
  And I fill in "layout_content" with "Hello, World!" 
  And I press "Create Layout"
  Then I should be on the admin layouts page
  And I should see "Successfully created the layout foobar"
  And I should see "foobar"
  And I should see "Delete"

@edit_layout
Scenario: Given I am logged in as an admin then I can edit a layout
  Given these layouts exist in the site "foobar.example.com" created by user "ak730"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  And I follow "foobar" 
  Then I should now be editing the layout "foobar"
  And the "layout[name]" field should contain "foobar"
  And the "layout[content]" field should contain "Hello, World!"
  When I fill in "layout[name]" with "baz" 
  And I fill in "layout[content]" with "Hello, <b>World!</b>" 
  And I press "Update Layout" 
  Then I should be on the admin layouts page
  And I should see "Successfully updated the layout baz"
  When I edit the layout "baz"
  Then I should now be editing the layout "baz"
  And the "layout[name]" field should contain "baz"
  And the "layout[content]" field should contain "Hello, <b>World!</b>"
  
@admin_edit_other_user_layout
Scenario: Given I am logged in as an admin then I can edit a layout created by another user
  Given these layouts exist in the site "foobar.example.com" created by user "rg874"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  And I follow "foobar" 
  When I fill in "layout[name]" with "baz" 
  And I fill in "layout[content]" with "Hello, <b>World!</b>" 
  And I press "Update Layout" 
  Then I should be on the admin layouts page
  And I should see "Successfully updated the layout baz"

  
@delete_layout
Scenario: Delete layout as an admin
  Given these layouts exist in the site "foobar.example.com" created by user "ak730"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  And I follow "Delete" 
  Then I should see "Successfully deleted the layout foobar"
  And I should be on the admin layouts page
  
@admin_delete_other_user_layout
Scenario: Given I am logged in as an admin then I can delete a layout created by another user
  Given these layouts exist in the site "foobar.example.com" created by user "rg874"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  And I follow "Delete" 
  Then I should see "Successfully deleted the layout foobar"
  And I should be on the admin layouts page
