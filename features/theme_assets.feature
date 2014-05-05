Feature: Manage theme asses

Background: Login to site and create theme assets
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these theme collections exist
    | name   |
    | blog   |
    | blue   |

  @theme_collections 
  Scenario: Show all the theme collections
    Given I view the theme collections in the site
    Then I should see the theme collections

  @update_theme_collection 
  Scenario: Update a theme collections name
    Given I view the theme collection "blog"
    When I change the theme collection name "blog" to "news"
    Then I should see "news" in the theme collections list
    And I should see the flash message "Successfully updated the theme collection news"

  @delete_theme_collection 
  Scenario: Delete a theme collection 
    Given I view the theme collections in the site
    When I edit the theme collection "blog" and delete it
    Then the theme collection should be removed from the theme collections list
    And I should see the flash message "Successfully deleted the asset collection blog"

  # Theme Assets
  @show_theme_asset_image @theme_asset @image_asset
  Scenario: Create a image asset in the collection blog
    Given I view the theme collection "blog"
    Then "columbo.png" should be listed within the image assets
    Then "rails.png" should be listed within the image assets

  @show_theme_asset_css @theme_asset @css_asset
  Scenario: Create a image asset in the collection blog
    Given I view the theme collection "blog"
    Then "theme_css.css" should be listed within the css assets

  @show_theme_asset_js @theme_asset @js_asset
  Scenario: Create a image asset in the collection blog
    Given I view the theme collection "blog"
    Then "theme_js.js" should be listed within the javascript assets
    Then "jquery-1.7.2.min.js" should be listed within the javascript assets

  @show_theme_asset_other @theme_asset @other_asset
  Scenario: Create a image asset in the collection blog
    Given I view the theme collection "blog"
    Then "hello.pdf" should be listed within the other assets
