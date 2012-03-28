Feature: Manage Site Assets 

Background: Login to site and create layouts
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these asset collections exist
    | name   |
    | images |
    | pdfs   |

  @site_assets_collections
  Scenario: Show all the site assets collections
    Given I view the site assets for the site
    Then I should see the site assets collections

  @site_assets_collections_create
  Scenario: Create a new site asset collection
    Given I view the site assets for the site
    When I create a new site asset collection with the name "illustrations"
    Then I should see "illustrations" in the site assets collections list
    And I should see the flash message "Successfully created the asset collection illustrations"

  @site_assets_collection_update
  Scenario: Update site asset collection name
    Given I view the site assets for the site
    When I change the asset collection name "sketches" to "illustrations"
    And I should see the flash message "Successfully updated the asset collection illustrations"

  @delete_asset_collection
  Scenario: Delete an asset collection
    Given I view the site assets for the site
    When I edit the site asset collection "images" and delete it
    Then the site asset collection "images" should be removed from the asset collections list
    And I should see the flash message "Successfully deleted the asset collection images"

  @javascript @delete_asset_collection_from_index
  Scenario: Delete an asset collection from the asset collection index page
    Given I view the site assets for the site
    When I delete the site assets collection "images" from the articles list
    Then the site asset collection "images" should be removed from the asset collections list
    And I should see the flash message "Successfully deleted the asset collection images"

