Feature: Admin Page Parts Management features

Background: Login create default site and page
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And these current states exist
| name      |
| published |
| draft     |
And these layouts exist in the site "foobar.example.com" created by user "ak730"
| name | content              |
| app  | Hello, World         |
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
And these pages exist in the site "foobar.example.com" created by user "ak730"
| title  | status    | 
| foobar | published | 
And I authenticates as cas user "ak730"

@new_page_part
  Scenario: Edit page part
    When I go to the admin pages page
    And I follow "foobar"
    Then I should now be editing the page "foobar"
    When I follow "Add Page Part"
    Then I should now be on the new admin page part page for the page "foobar"
    When I fill in "page_part_name" with "sidebar"
    And I press "Create Page Part"
    Then I should now be editing the page "foobar"
    And I should see "Successfully created the page part sidebar"

@delete_page_part
  Scenario: Delete a page part when more than one exists
    When the page part "sidebar" exists in the page "foobar" 
    And I follow "Delete"
    Then I should now be editing the page "foobar"
    And I should see "Successfully deleted the page part sidebar"

@cannot_delete_last_page_part
  Scenario: Cannot delete page part if it is the only one on the page
    When I go to the admin pages page
    And I follow "foobar"
    Then I should now be editing the page "foobar"
    And I should not see "Delete" within "ul#page_parts_nav"

