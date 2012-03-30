Feature: Admin Layout Management Features user with editor role

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "baz" exists with the role of "admin" in the site "foobar.example.com"
And the user "ak730" exists with the role of "editor" in the site "foobar.example.com"
And I login as the user "ak730" to the site "foobar.example.com"

# Actions_Blocked 

@editor_cannot_view_layouts
Scenario: Editor cannot view layouts
  Given these layouts exist in the site "foobar.example.com" created by user "baz"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  Then I should see "403"
  
@admin_should_not_access_other_site 
Scenario: Should not be able to access site the user is not associated with
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin layouts page
  Then I should be on the new admin user session page

@editor_access_new_layout_page
Scenario: Editor cannot create layouts
  When I go to the new admin layout page
  Then I should see "403"
  
@editor_access_edit_layout_page
Scenario: User with the role editor cannot edit layouts
  Given these layouts exist in the site "foobar.example.com" created by user "baz"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I edit the layout "foobar"
  Then I should see "403" 
