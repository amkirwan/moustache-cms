Feature: Admin Media File Management Features

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And the user with the role exist
 | user   | role   | site               |
 | foobar | admin  | foobar.example.com |
 | bar    | editor | foobar.example.com |
And I authenticates as cas user "ak730"



@index_media_file
Scenario: Navigate to the Layout#index page
  Given these media files exist in the site "foobar.example.com" created by user "ak730"
  | name   | content       |
  | foobar | Hello, World! |
  | bar    | Hello, World! |
  When I go to the admin layouts page
  Then I should be on the admin layouts page
  And I should see "foobar"
  And I should see the "delete" button
  And I should see "Add New Layout"