Feature: Manage Layouts

Background: Login to site and create layouts
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"

  @layouts
  Scenario: Show all the layouts for the site
    Given these layouts exist
     | name     |
     | homepage |
     | blog     |
    And I view the layouts in the site
    Then I should see the layouts listed

  @create_layout
  Scenario: Create Layout
    Given I want to create a new layout in the site
    When I create a layout with the name "qux"
    Then I should see "qux" in the layouts list
    And I should see the flash message "Successfully created the layout qux"

  @update_layout
  Scenario: Update Layout
    Given I view the layouts in the site
    When I change the layout name to "quuxer"
    Then I should see "quuxer" in the layouts list
    And I should see the flash message "Successfully updated the layout quuxer"

  @delete_layout
  Scenario: Delete layout
    Given I view the layouts in the site
    When I edit the layout "foobar" and delete it
    Then the layout should be removed from the layouts list
    And I should see the flash message "Successfully deleted the layout foobar"

  @javascript @delete_layout_from_index
  Scenario: Delete layout from the index page
    Given I view the layouts in the site
    When I delete the layout "foobar" from the layouts list
    Then the layout should be removed from the layouts list
    And I should see the flash message "Successfully deleted the layout foobar"


