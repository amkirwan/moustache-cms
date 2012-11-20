Feature: Manage Site Assets 

Background: Login to site and create layouts
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these asset collections exist
    | name   |
    | images |
    | pdfs   |

  @site_assets_collections @upload
  Scenario: Show all the site assets collections
    Given I view the site assets for the site
    Then I should see the site assets collections

  @site_assets_collections_create @upload
  Scenario: Create a new site asset collection
    Given I view the site assets for the site
    When I create a new site asset collection with the name "illustrations"
    Then I should see "illustrations" in the site assets collections list
    And I should see the flash message "Successfully created the asset collection illustrations"

  @site_assets_collection_update @upload
  Scenario: Update site asset collection name
    Given I view the site assets for the site
    When I change the asset collection name "sketches" to "illustrations"
    And I should see the flash message "Successfully updated the asset collection illustrations"

  @delete_asset_collection @upload
  Scenario: Delete an asset collection
    Given I view the site assets for the site
    When I edit the site asset collection "images" and delete it
    Then the site asset collection "images" should be removed from the asset collections list
    And I should see the flash message "Successfully deleted the asset collection images"
    
# Site Assets
  @create_site_asset_image @upload
  Scenario: Create a image asset in the collection blog
    Given I view the site asset collection "blog"
    When I create the site asset named "rails.png"
    Then "rails.png" should be listed within the site assets

  @delete_site_asset @upload
  Scenario: Delete a asset
    Given I view the site asset collection "image"
    When I create the site asset named "rails.png"
    And I edit the site asset "rails.png" and delete it
    Then I should not see the "rails.png" in the image list
    And I should see the flash message "Successfully deleted the asset rails.png"
