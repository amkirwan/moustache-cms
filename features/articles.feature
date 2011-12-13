Feature: Admin Article Feature

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I login as the user "ak730" to the site "foobar.example.com"
And these article collections exist in the site "foobar.example.com" created by user "ak730"
    | name   |
    | foobar |
    | bar    |

@list_articles
  Scenario: List Articles
    Given these articles exist in the article collection "foobar"
      | title     |
      | article 1 |
      | article 2 |
      | article 3 |
    When I view the articles in the collection "foobar"
    Then I should see all the articles in the collection "foobar"

@create_article
  Scenario: Create Article Collection
    Given I view the article collection "foobar"
    When I follow "New Article"
    And I create an article titled "My Blog Post"
    Then I should see an article titled "My Blog Post" 
