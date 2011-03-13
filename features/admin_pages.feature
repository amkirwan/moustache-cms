Feature: Admin Pages Management Features

@index_page_view
Scenario: Navigate to the Pages#index page
  Given I login as "ak730" with the role of "admin"
  And these pages exist with current state
  | title  | status    |
  | foobar | published |
  | bar    | draft     |
  When I go to the admin pages page
  Then I should be on the admin pages page
  And I should see "foobar" within "tr#foobar"
  And I should see "Published" within "tr#foobar"
  And I should see "delete" button within "tr#foobar"
  And I should see "bar" within "tr#bar"
  And I should see "Draft" within "tr#bar"
  And I should see "delete" button within "tr#bar"
  And I should see "Add New Page"
  
@create_new_page
Scenario: Create a new page
  Given I login as "ak730" with the role of "admin"
  And these current states exist
  | name      |
  | published |
  | draft     |
  And these layouts exist
  | name | content              |
  | app  | Hello, World         |
  | baz  | Hello, <b>World!</b> |
  When I go to the admin pages page
  And I follow "Add New Page"
  Then I should be on the new admin page page
  And I fill in "page_title" with "foobar" within "div#add_new_page"
  And I select "app" from "page_layout_id" within "div#add_new_page"
  And I select "haml" from "page_filter" within "div#add_new_page"
  And I select "published" from "page_current_state_attributes_id" within "div#add_new_page"
  And I press "Create Page" within "div#add_new_page"
  Then I should be on the admin pages page
  And I should see "Successfully created page foobar"
  And I should see "foobar" within "tr#foobar"
  And I should see "Published" within "tr#foobar"
  And I should see "delete" button within "tr#foobar"