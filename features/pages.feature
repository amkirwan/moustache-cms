Feature: Manage Pages

Background: Login to site
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  Given these pages exist 
    | title  |  status   |
    | foobar | published |
    | bar    | draft     |
    | qux    | published |

  @pages
  Scenario: List index pages
    Given I view the pages in the site
    Then I should see the pages listed

  @create_page
  Scenario: Create page
    Given I want to create a new page in the site
    When I create a page with the title "baz"
    Then I should see "baz" in the pages list
    And I should see the flash message "Successfully created the page baz"

  @update_page
  Scenario: Update page
    Given I view the pages in the site
    When I change the page title of "foobar" to "xbars"
    Then I should see "xbars" in the pages list
    And I should see the flash message "Successfully updated the page xbars"

  @delete_page
  Scenario: Delete page
    Given I view the pages in the site
    When I edit the page "foobar" and delete it
    Then I should see the flash message "Successfully deleted the page foobar"
    And the page should be removed from the pages list

  # Javascript steps
  @javascript @delete_page_from_page_index
  Scenario: Destroy page from index page
    Given I view the pages in the site
    When I delete the page "foobar" from the pages list
    Then I should see the flash message "Successfully deleted the page foobar"
    And the page should be removed from the pages list

  @javascript @expand_child_pages
  Scenario: Request child pages when clicking on the parent page's fold arrow
    Given the page "foobar" has a child page "quuxer"
    And I view the pages in the site
    When I show "foobar"'s child pages 
    Then "quuxer" should be expanded in the view

  @javascript @hide_child_pages
  Scenario: When I click on on a pages fold arrow it should hide the child pages when they are showing
    Given the page "foobar" has a child page "quuxer"
    And I view the pages in the site
    When I hide the child page "quuxer"
    Then "quuxer" should not be expanded within "foobar"

  @javascript @delete_double_confirm
  Scenario: Destroy page that has child pages accepting double confirmation
    Given the page "foobar" has a child page "quuxer"
    And I view the pages in the site
    When I delete the page "fooboar" from the pages list that has a child page then I should need to double confirm the delete
    Then I should see the flash message "Successfully deleted the page foobar"
    And the page should be removed from the pages list

  @javascript @change_page_position
  Scenario: Move page
    Given I view the pages in the site
    When I move the "qux" to come before "foboar"
    Then I should see the flash message "Updated Page Position"

  @javascript @change_page_part_name
  Scenario: Changing a page part name should change the name in the tab
    Given I view the pages in the site
    When I edit the page "foobar"
    And I change the page part name to "changed_page_part_name"
    Then page part nav tab should show "changed_page_part_name"


  @javascript @change_page_position
  Scenario: Move page
    Given I view the pages in the site
    When I move the "qux" to come before "foboar"
    Then I should see the flash message "Updated Page Position"

  @javascript @change_page_part_name
  Scenario: Changing a page part name should change the name in the tab
    Given I view the pages in the site
    When I edit the page "foobar"
    And I change the page part name to "changed_page_part_name"
    Then page part nav tab should show "changed_page_part_name"

  @javascript @add_page_part
  Scenario: Add a page part to the page
    Given I view the pages in the site
    When I edit the page "foobar"
    And I add a page part 
    Then it should be added to the page

  @javascript @selected_page_part
  Scenario: Change the page part being edited by clicking in the page part nav tab should make it the selected page and hide the other page
    Given I view the pages in the site
    When I edit the page "foobar" with an additional page part baz
    And I edit the page part baz
    Then it should be the selected page part
    
  @javascript @delete_page_part
  Scenario: Delete a page part 
    Given I view the pages in the site
    When I edit the page "foobar" with an additional page part baz
    And I delete the page part baz
    Then the page part baz should be removed from the page

  @javascript @switch_between_page_parts
  Scenario: Switching back and forth between a page part and a new page part added
    Given I view the pages in the site
    When I edit the page "foobar" with an additional page part baz
    And I add a page part
    Then I can switch between the page parts in the page part navigation tabs

  @javascript @add_meta_tag
  Scenario: add meta tag to the page
    Given I view the pages in the site
    When I edit the page "foobar"
    And I expand "Page Meta Tags"
    And I add an additional meta tag with the name "viewport" and the content "width=device-width, initial-scale=1.0" and click "Update Page"
    Then I should see the flash message "Successfully updated the page foobar"

  @javascript @delete_meta_tag
  Scenario: Delete added meta tag
    Given I view the pages in the site
    When I add a new meta tag to the page "foobar"
    And I delete the last meta tag added to the page
