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
    And I follow "Add Meta Tag"
    And I fill in "meta_tag_name" with "DC.author"
    And I fill in "meta_tag_content" with "Foobar Baz"
    And I press "Create Meta Tag"
    Then I should now be editing the page "foobar"
    And I should see "Successfully created meta tag DC.author"

@edit_meta_tag_for_page
  Scenario: Edit an exsisting meta_tag for a page
    Given the page "foobar" with a custom meta tag "DC.author" with the content "Foobar Baz"
    When I follow "Edit" 
    Then I should now be editing the meta tag "DC.author" for the page "foobar"
    When I fill in "meta_tag_name" with "viewport"
    And I fill in "meta_tag_content" with "initial-scale=1.0"
    And I press "Update Meta Tag"
    Then I should now be editing the page "foobar"
    And I should see "Successfully updated the meta tag viewport"

@delete_meta_tag_for_page
  Scenario: Deleting a meta tag for a page
    Given the page "foobar" with a custom meta tag "DC.author" with the content "Foobar Baz"
    When I follow "Delete"
    Then I should now be editing the page "foobar"
    And I should see "Successfully deleted the meta tag DC.author"

@delete_meta_tag_for_page
  Scenario: Deleting a meta tag for a page
    Given the page "foobar" with a custom meta tag "DC.author" with the content "Foobar Baz"
    When I follow "Edit"
    Then I should now be editing the meta tag "DC.author" for the page "foobar"
    When I follow "Delete Meta Tag"
    Then I should now be editing the page "foobar"
    And I should see "Successfully deleted the meta tag DC.author"
