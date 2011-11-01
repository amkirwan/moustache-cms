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

