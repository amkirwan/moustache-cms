Feature: Manage theme asses

Background: Login to site and create theme assets
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these theme collections exist
    | name   |
    | blog   |
    | blue   |

  @theme_collections @upload
  Scenario: Show all the theme collections
    Given I view the theme collections in the site
    Then I should see the theme collections

  @update_theme_collection @upload
  Scenario: Update a theme collections name
    Given I view the theme collection "blog"
    When I change the theme collection name "blog" to "news"
    Then I should see "news" in the theme collections list
    And I should see the flash message "Successfully updated the theme collection news"

  @delete_theme_collection @upload
  Scenario: Delete a theme collection 
    Given I view the theme collections in the site
    When I edit the theme collection "blog" and delete it
    Then the theme collection should be removed from the theme collections list
    And I should see the flash message "Successfully deleted the asset collection blog"

  # Theme Assets
  @create_theme_asset_image @upload
  Scenario: Create a image asset in the collection blog
    Given I view the theme collection "blog"
    When I create a theme asset named "columbo.png"
    Then "columbo" should be listed within the image assets

  @delete_theme_asset @upload
  Scenario: Delete a asset
    Given I view the theme collection "blog"
    When I edit the theme asset "columbo" and delete it
    Then the theme asset image "columbo" should be removed
