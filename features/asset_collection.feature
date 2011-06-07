Feature: Admin Asset Collections

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And I authenticates as cas user "ak730"
And the user with the role exist
 | user  | role   | site               |
 | rg874 | admin  | foobar.example.com |
 | jmb42 | editor | foobar.example.com |  
 
@index
Scenario: Navigate to the Layout#index page
 Given these collections exist in the site "foobar.example.com" created by user "ak730"
 | name   | 
 | foobar | 
 | bar    |
 When I go to the admin site assets page
 Then I should be on the admin site assets page
 And I should see "foobar"
 And I should see the "delete" button
 And I should see "Add Asset"      