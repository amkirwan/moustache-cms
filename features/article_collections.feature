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
