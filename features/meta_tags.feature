Feature: Adding MetaTags to a document


Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
Given these pages exist in the site "foobar.example.com" created by user "ak730"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     | 
And I authenticates as cas user "ak730"

@create_new_meta_tag_for_page
Scenario:  Add new meta tags to a page
When I go to the admin pages page
And I follow "foobar"
When I follow "Add Meta Tag"
