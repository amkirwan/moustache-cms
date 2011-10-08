Feature: Adding Tag Attribute to a document


Background: Login create default site
  Given the site "foobar" exists with the domain "example.com"
  And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
  And these theme assets exist in the site "foobar.example.com" created by user "ak730"
   | name      | file          | 
   | theme_css | theme_css.css | 
   | theme_js  | theme_js.js   | 
   | rails     | rails.png     | 

  And I authenticates as cas user "ak730"

@create_new_tag_attributes
  Scenario:  Add new tag attribute
    When I go to the admin theme assets page
    And I follow "theme_css" 
    And I follow "Add Tag Attribute"
    And I fill in "tag_attr_name" with "media"
    And I fill in "tag_attr_value" with "screen"
    And I press "Create Tag Attribute"
    Then I should now be editing the theme asset "theme_css"
    And I should see "Successfully created the tag attribute media"


