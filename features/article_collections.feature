Feature: Admin Article Collections

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I login as the user "ak730" to the site "foobar.example.com"


@list_collections
Scenario: List ArticleCollections
  Given these article collections exist in the site "foobar.example.com" created by user "ak730"
    | name   |
    | foobar |
    | bar    |
  When I view the article collections
  Then I should see all the article collections
    | name   |
    | foobar |
    | bar    |

@create_article_collection
Scenario: Create Article Collection
    Given I am on the admin article collections page
    When I follow "New Article Collection"
    And I create a article collection named "foobar"
    Then I sould see an article collection named "foobar" 
