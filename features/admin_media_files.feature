Feature: Admin Media File Management Features

Background: Login create default site
Given I login as "ak730" with the role of "admin"
And the site "foobar" exists
And the user with the role exist
| user   | role   |
| foo    | admin  |
| cds27  | admin |
| foobar | editor |

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