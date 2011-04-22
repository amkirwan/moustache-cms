Feature: Admin Pages Management Features

Background: Login create default site
Given I login as "ak730" with the role of "admin"
And the site "foobar" exists

@index_page_view
Scenario: Navigate to the Pages#index page
  Given these pages exist with current state in the site "foobar" with the user "ak730"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     | 
  When I go to the admin pages page
  Then I should be on the admin pages page
  And I should see "foobar" within "tr#foobar"
  And I should see "published" within "tr#foobar"
  And I should see the "delete" button
  And I should see "bar" within "tr#bar"
  And I should see "draft" within "tr#bar"
  And I should see the "delete" button
  And I should see "Add New Page"
  
@create_new_page_root_page
Scenario: Create a new page
  Given the user with the role exist
  | user   | role   |
  | foo    | admin  |
  | bar    | editor |
  | foobar | editor |
  And these current states exist
  | name      |
  | published |
  | draft     |
  And these layouts exist in the site "foobar" with the user "ak730"
  | name | content              |
  | app  | Hello, World         |
  | baz  | Hello, <b>World!</b> |
  When I go to the admin pages page
  And I follow "Add New Page"
  Then I should be on the new admin page page
  And I fill in "page_title" with "foobar" 
  And I fill in "page_meta_title" with "meta_title_foobar"
  And I fill in "page_meta_keywords" with "meta_keywords_foobar"
  And I fill in "page_meta_description" with "meta_description_foobar" 
  And I check "editor_id_ak730" 
  And I check "editor_id_foo"
  And I select "app" from "page_layout_id" 
  And I select "published" from "page_current_state_attributes_id" 
  And I fill in "page_page_parts_attributes_0_name" with "content" 
  And I select "markdown" from "page_page_parts_attributes_0_filter" 
  And I fill in "page_page_parts_attributes_0_content" with "Hello, World!" 
  And I press "Create Page" 
  Then I should be on the admin pages page
  And I should see "Successfully created page foobar"
  And I should see "foobar" 
  And I should see "published" 
  And I should see the "delete" button