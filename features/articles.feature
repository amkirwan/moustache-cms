Feature: Manage Articles

Background: Login to site and create articles
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these article collections exist
    | name   |
    | blog   |
    | news   |
  And these articles exist in the collection "blog"
    | title   |
    | foobar  | 

  @article_collections
  Scenario: Show all the article collections
    Given I view the article collections for the site
    Then I should see the article collections

  @articles_in_ac
  Scenario: Show all the articles for a given article collection
    Given I view the article collection "blog"
    Then I should see all the articles in the article collection "blog"

  @article_collection_create
  Scenario: Create a new article collection
    Given I view the article collections for the site
    When I create a article collection with the name "spotlight"
    Then I should see "spotlight" in the article collections list
    And I should see the flash message "Successfully created the article collection spotlight"

  @create_article
  Scenario: Create an article in the collection "blog"
    Given I view the article collection "blog"
    When I create a article "lorem ipsum"
    Then I should see "lorem ipsum" in the articles list
    And I should see the flash message "Successfully created the article lorem ipsum in the collection blog"

  @article_collection_update
  Scenario: Update a article collection
    Given I view the article collections for the site
    When I change the article collection "blog" to "qux"
    Then I should see "qux" in the article collections list
    And I should see the flash message "Successfully updated the article collection qux"

  @update_article
  Scenario: Update an article in the collection "blog"
    Given I view the article collection "blog"
    When I update the article "foobar" to "ipsum lorem"
    Then I should see "ipsum lorem" in the articles list
    And I should see the flash message "Successfully updated the article ipsum lorem in the collection blog"

  @delete_article_collection
  Scenario: Delete an article collection
    Given I view the article collections for the site
    When I edit the article collection "blog" and delete it
    Then the article collection "blog" should be removed from the article collections list
    And I should see the flash message "Successfully deleted the article collection blog"

  @delete_article
  Scenario: Delete article
    Given I view the article collection "blog"
    When I edit the article "foobar" and delete it
    Then the article "foobar" should be removed from the articles in the article collection blog
    And I should see the flash message "Successfully deleted the article foobar"

  @javascript @delete_article_collection 
  Scenario: Delete an article collection from article collections index page
    Given I view the article collections for the site
    When I delete the article collection "blog" from the article collections list
    Then the article collection "blog" should be removed from the article collections list
    And I should see the flash message "Successfully deleted the article collection blog"

  @javascript @delete_article_from_index
  Scenario: Delete an article from the article collections list of articles
    Given I view the article collection "blog"
    When I delete the article "foobar" from the articles list
    Then the article "foobar" should be removed from the article collections list
    And I should see the flash message "Successfully deleted the article foobar"
