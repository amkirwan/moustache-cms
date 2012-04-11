Feature: Manage Authors

Background: Login to site and create author
  Given I have the site "foobar" setup
  And I am an authenticated user with the role of "admin"
  And these authors exist
    | firstname  | lastname  |
    | foobar     | handlebar |
    | baz        | handlebar |

  @authors @upload
  Scenario: Show all the authors
    Given I view the authors in the site
    Then I should see the authors listed

  @create_author @upload
  Scenario: Create Author
    Given I want to create a author in the site
    When I create a author with the firstname "Qux" and the lastname "Handlebar"
    Then I should see "Qux Handlebar" in the authors list

  @update_author @upload
  Scenario: Update Author
    When I change the author Foobar Handlebar's firstname to "Peter" and the lastname to "Falk"
    Then I should see "Peter Falk" in the authors list
    
  @delete_author @upload
  Scenario: Delete Author
    Given I view the authors in the site
    When I edit the author "Foobar Handlebar" and delete it
    Then the author should be removed from the authors list

  @javascript @delete_author_from_index @upload
  Scenario: Delete an author form the index apge
    Given I view the authors in the site
    When I delete the author "Foobar Handlebar" from the authors list
    Then the author should be removed from the authors list

