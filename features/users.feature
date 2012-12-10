Feature: Manage Users

Background: Login to site and create users
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these users have admin access
    | user | firstname | lastname  | role   | 
    | bar  | bar       | Moustache | admin  |
    | baz  | baz       | Moustache | admin  |
    | qux  | qux       | Moustache | editor |
  Given I view the users in the site

  @users
  Scenario: List the users with access to the site
    Then I should see the users listed

  @create_user
  Scenario: Create a user with the role of admin can create a new user
    When I create the user Patrick Kane
    Then the user Patrick Kane should be on the list of users with access to the sites admin section
    And I should see the flash message "Successfully created the user profile for Patrick Kane"

  @update_user
  Scenario: Edit a user account and change the first and lastname
    When I change the fullname to Patrick Kane and username to pk88 of the user qux
    Then I should see the flash message "Successfully updated the user profile for Patrick Kane"

  @update_user_password
  Scenario: Updating a users password
    When I change my password to "password9"
    Then I should see the flash message "Successfully updated the password for Anthony Kirwan"

  @delete_user
  Scenario: Delete User account
    When I edit the user profile for "Qux Moustache" and delete the user profile
    Then I should see the flash message "Successfully deleted the user profile for Qux Moustache"
    And the user should be removed from the users list

  @javascript @delete_user_from_users_index
  Scenario: Delete user
    When I delete the user "qux" from the sites list of users
    Then I should see the flash message "Successfully deleted the user profile for Qux Moustache"
    And the user should be removed from the users list
