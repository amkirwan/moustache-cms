Feature: Admin Managing Authors

Background: Login to site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I login as the user "ak730" to the site "foobar.example.com"


@list_collections
  Scenario: List Authors
    Given these authors exists in the site "foobar.example.com"
      | firstname | middlename | lastname | profile                          |
      | Anthony   |            | Kirwan   | This is Anthony Kirwan's profile |
      | Bob       |            | Gimlich  | This is Bob Gimlich's profile    |
    When I view the authors page
    Then show me the page
    Then I should see the authors
      | firstname | middlename | lastname |
      | Anthony   |            | Kirwan   | 
      | Bob       |            | Gimlich  |
