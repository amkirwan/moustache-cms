Feature: Manage Snippets

Background: Login to site and create layouts
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these snippets exist
    | name   |
    | foobar |
    | baz    |

  @snippets
  Scenario: Show all the snippets for the site
    Given I view the snippets in the site
    Then I should see the snippets listed

  @create_snippet
  Scenario: Create a new snippet
    Given I want to create a new snippet in the site
    When I create a snippet with the name "qux"
    Then I should see "qux" in the snippets list
    And I should see the flash message "Successfully created the snippet qux"

  @update_snippets
  Scenario: Update a snippet
    Given I view the snippets in the site
    When I change the snippet name to "quuxer"
    Then I should see "quuxer" in the snippets list
    And I should see the flash message "Successfully updated the snippet quuxer"
    
  @delete_snippet
  Scenario: Delete a snippet
    Given I view the snippets in the site
    When I edit the snippet "foobar" and delete it
    Then the snippet should be removed from the snippets list
    And I should see the flash message "Successfully deleted the snippet foobar"

  @javascript @delete_snippet_from_index
  Scenario: Delete snippet from the snippet index page
    Given I view the snippets in the site
    When I delete the snippet "foobar" from the snippets list
    Then the snippet should be removed from the snippets list
    And I should see the flash message "Successfully deleted the snippet foobar"
