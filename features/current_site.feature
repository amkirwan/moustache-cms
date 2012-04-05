Feature: Manage Sites

Background: Login to the site "foobar" and manage the settings
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"

  @sites
  Scenario: List all the sites running within the given instance
    Given these additional sites exist
      | name |
      | baz  |
      | qux  |
    When I view all the sites 
    Then I should see all the sites listed

  @create_site
  Scenario: After creating the initial site create a new site named blog
    Given I want to create another site
    When I create a site with the name "blog"
    Then I should see "blog" in the sites list
    And I should see the flash message "Successfully created the site blog"

  @update_site
  Scenario: Update a sites settings
    When I update the site name to "qux"
    Then I should see the flash message "Successfully updated the site qux"

  @delete_site
  Scenario: Delete the site
    When I view the site settings
    And I delete the site
    Then the site should be deleted

  @javascript @add_additional_domain
  Scenario: Add additional domain
    When I view the site settings
    And I add the domain name "blog.com"
    Then I should see the flash message "Successfully updated the site foobar"

  @javascript @remove_added_domain
  Scenario: Delete added domain 
    When I add an additional domain name field and delete it
    Then the additional domain name should be removed from the site

  @javascript @add_meta_tag
  Scenario: Add meta tag to site
    When I view the site settings
    And I add an additional meta tag with the name "viewport" and the content "width=device-width, initial-scale=1.0" and click "Update Site"
    Then I should see the flash message "Successfully updated the site foobar"

  @javascript @delete_meta_tag
  Scenario: Delete added meta tag
    When I view the site settings
    And I add an additional meta tag with the name "viewport" and the content "width=device-width, initial-scale=1.0" and click "Update Site"
    And I delete the last meta tag added to the site
    Then the additional meta tag should be removed from the site
