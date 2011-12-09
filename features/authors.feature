Feature: Admin Managing Authors

Background: Login to site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I login as the user "ak730" to the site "foobar.example.com"


@list_collections
  Scenario: List Authors
    Given these authors exists in the site "foobar.example.com"
      | firstname | middlename  | lastname | profile                          |
      | Anthony   | M           | Kirwan   | This is Anthony Kirwan's profile |
      | Bob       |             | Gimlich  | This is Bob Gimlich's profile    |
    When I view the authors page
    Then I should see the authors
      |   full_name      |
      | Anthony M Kirwan |
      | Bob Gimlich      |

@create_an_author
  Scenario: Create Author
    Given I am on the admin authors page
    When I follow "New Author"
    And I create a new author
    Then I should see the author "Anthony M Kirwan"

@update_author
  Scenario: Update Author
    Given these authors exists in the site "foobar.example.com"
      | firstname | middlename  | lastname | profile                          |
      | Anthony   | M           | Kirwan   | This is Anthony Kirwan's profile |
      | Bob       |             | Gimlich  | This is Bob Gimlich's profile    |
    When I view the authors page

