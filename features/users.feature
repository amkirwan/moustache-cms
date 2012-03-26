Feature: Manage Users

Background: Login to site and create users
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these users have admin access
    | user | role  |
    | foo  | admin |
    | bar  | admin |
    | qux  | editor|

  @users
  Scenario: List the users with access to the site
    Given I view the list of users with access to the site admin section
    Then I should see the users listed

  @create_user
  Scenario: Create a user with the role of admin can create a new user
    Given I view the list of users with access to the site admin section
    When I create the user Patrick Kane
    Then the user Patrick Kane should be on the list of users with access to the sites admin section
    And I should see the flash message "Successfully created the user profile for Patrick Kane"

  @update_user
  Scenario: Edit a user account and change the first and lastname
    Given I view the list of users with access to the site admin section
    When I change the fullname to Patrick Kane and username to pk88 of the user foo
    Then I should see the flash message "Successfully updated the user profile for Patrick Kane"

  @update_user_password
  Scenario: Updating a users password
    Given I view the list of users with access to the site admin section
    When I change my password to "password9"
    Then I should see the flash message "Successfully updated the password for Anthony Kirwan"

  @delete_user
  Scenario: Delete User account
    Given I view the list of users with access to the site admin section
    When I edit the user profile "foo" and delete the user
    Then I should see the flash message "Successfully deleted the user profile for Foobar Baz"
    And the user should be removed from the users list

  @javascript @delete_user_from_users_index
  Scenario: Delete user
    Given I view the list of users with access to the site admin section
    When I delete the user "foo" from sites list of users
    Then I should see the flash message "Successfully deleted the user profile for Foobar Baz"
    And the user should be removed from the users list
