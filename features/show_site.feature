Feature: show website created in cms

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"

@show_homepage
Scenario: When I go to the index page I should see the root page for the site
  Given the Homepage exists in the site "foobar.example.com"
  When I go to the sites homepage
  Then I should see the homepage

@show_about_page
  Scenario: When I go the another page in the site that is a child of the homepage
    Given the "about" page exists in the site "foobar.example.com"
    When I go to the sites "about" page
    Then I should see the "about" page

@show_blog
  Scenario: Show the articles for the article collection blog
    Given the "blog" collection page exists in the site "foobar.example.com"
    And these article collections exist with the permalink prefix
      | name |
      | blog |
    And these articles exist in the collection "blog"
      | title  |
      | foobar |
      | baz    |
      | qux    |
    When I go to the sites "blog" page
    Then I should see the list of article titles for the article collection "blog"

@show_blog_on_homepage
  Scenario: Show 
    Given the Homepage is a blog in the site "foobar.example.com"
    And these article collections exist without a permalink prefix
      | name |
      | blog |
    And these articles exist in the collection "blog"
      | title  |
      | foobar |
      | baz    |
      | qux    |
    When I go to the sites homepage with the article collection "blog"
    Then I should see the list of article titles for the article collection "blog"

@show_blog_post
  Scenario: Go to the aritcle in the blog collection 
    Given the "blog" collection page exists in the site "foobar.example.com"
    And these article collections exist with the permalink prefix
      | name |
      | blog |
    And these articles exist in the collection "blog"
      | title  |
      | foobar |
      | baz    |
      | qux    |
    When I view the "blog" post with the title "foobar"
    Then I should see the blog post "foobar" 

@show_blog_post_on_homepage
  Scenario: Go to the aritcle in the blog collection 
    Given the Homepage is a blog in the site "foobar.example.com"
    And these article collections exist without a permalink prefix
      | name |
      | blog |
    And these articles exist in the collection "blog"
      | title  |
      | foobar |
      | baz    |
      | qux    |
    When I go to the sites homepage with the article collection "blog"
    And I view the article "foobar"
    Then I should see the blog post "foobar"
