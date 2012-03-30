Feature: Admin Article Collections

Background: Login to site
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
    Then I should see an article collection named "foobar" 

@show_article_collection
  Scenario: Show the articles in the article colleciton
    Given these article collections exist in the site "foobar.example.com" created by user "ak730"
      | name   |
      | foobar |
      | bar    |
    And these articles exist in the article collection "foobar"
      | title         |
      | article       |
      | article1      |
      | article2      |
    When I view the article collection "foobar"
    Then I should see the articles in the collection
      | title         |
      | article       |
      | article1      |
      | article2      |

@update_article_collection
  Scenario: Update Article Collection Properties
    Given these article collections exist in the site "foobar.example.com" created by user "ak730"
      | name   |
      | foobar |
      | bar    |
    And these articles exist in the article collection "foobar"
      | title         |
      | article       |
      | article1      |
      | article2      |
    When I view the article collection "foobar"
    And I click the link "Edit Collection Props"
    And I change the name to "foobar baz"
    And I press the button "Update Article Collection"
    Then I should see an article collection named "foobar baz"

@delete_article_collection
  Scenario: Delete Article Collection
    Given these article collections exist in the site "foobar.example.com" created by user "ak730"
      | name   |
      | foobar |
      | bar    |
    And these articles exist in the article collection "foobar"
      | title         |
      | article       |
      | article1      |
      | article2      |
    When I view the article collection "foobar"
    And I click the link "Delete Collection"
    Then I should be returned to the "admin article collections page"
    Then I should see the message "Successfully deleted the article collection foobar"

