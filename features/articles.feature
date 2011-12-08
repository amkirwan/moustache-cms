Feature: Admin Article Feature

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I login as the user "ak730" to the site "foobar.example.com"
And these article collections exist in the site "foobar.example.com" created by user "ak730"
    | name   |
    | foobar |
    | bar    |
When I view the article collections


