Feature: Admin User Management Features as user with admin role

Background: Login create default site
  Given the site "foobar" exists with the domain "example.com"
  And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
  And I login as the user "ak730" to the site "foobar.example.com"

@admin_should_not_access_other_site 
Scenario: Should not be able to access another sites layout the admin is not associated with
  Given the site "baz" exists with the domain "example.dev"
  When I edit the current site "baz"
  Then I should be on the new admin user session page
 

@site_settings
  Scenario: Givin I am logged in as admin then I can edit the site settings
    When I edit the current site "foobar"
    Then I should now be editing the current site "foobar"
    And I fill in "site[name]" with "qux"
    And I press "Update Site"
    Then I should now be editing the current site "qux"
    And I should see "Successfully updated the site qux"

@create_new_meta_tag_for_current_site
  Scenario:  Add new meta tags to the site
    When I edit the current site "foobar"
    And I follow "Add Meta Tag"
    And I fill in "meta_tag_name" with "DC.author"
    And I fill in "meta_tag_content" with "Foobar Baz"
    And I press "Create Meta Tag"
    Then I should now be editing the current site "foobar"
    And I should see "Successfully created the meta tag DC.author"

@delete_meta_tag_for_current_site
  Scenario: Deleting a meta tag for a page
    Given the site "foobar" with a custom meta tag "DC.author" with the content "Foobar Baz"
    When I follow "Delete"
    Then I should now be editing the current site "foobar"
    And I should see "Successfully deleted the meta tag DC.author"

@create_domain_name_for_current_site
  Scenario: Add additional domain name the current site resolves to
    When I edit the current site "foobar"
    And I follow "Add Domain Name"

    When I fill in "site[domain_name]" with "example.org"
    And I press "Create Domain Name"
    Then I should now be editing the current site "foobar"
    And I should see "Successfully created the domain name example.org"
    Then the "site[domain_names][]" field should contain "example.org"

@delete_domain_name_for_current_site
  Scenario: Delete additional domain name for the current site
    When I edit the current site "foobar" with the additional domain "example.org"
    When I follow "Delete" within "ul.domains_list"
    Then I should now be editing the current site "foobar"
    And I should see "Successfully deleted the domain name example.org"
