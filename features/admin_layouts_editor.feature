Feature: Admin Layout Management Features user with editor role

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "baz" exists with the role of "admin" in the site "foobar.example.com"
And the user "ak730" exists with the role of "editor" in the site "foobar.example.com"
And I authenticates as cas user "ak730"

@editor_cannot_view_layouts
Scenario: Editor cannot view layouts
  Given these layouts exist in the site "foobar.example.com" created by user "baz"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  Then I should see "403"

@editor_cannot_create_new_layout
Scenario: Editor cannot create layouts
  When I go to the new admin layouts page
  Then I should see "403"