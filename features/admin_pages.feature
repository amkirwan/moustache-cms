Feature: Admin Pages Management Features

Background: Login create default site
Given I login as "ak730" with the role of "admin"
And the site "foobar" exists
And these current states exist
| name      |
| published |
| draft     |
And these layouts exist in the site "foobar" created by user "ak730"
| name | content              |
| app  | Hello, World         |
| baz  | Hello, <b>World!</b> |
And the user with the role exist
| user   | role   |
| foo    | admin  |
| cds27  | admin |
| foobar | editor |

@index_page_view
Scenario: Navigate to the Pages#index page
  Given these pages exist in the site "foobar" created by user "ak730"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     | 
  When I go to the admin pages page
  Then I should be on the admin pages page
  And I should see "foobar" within "li#foobar"
  And I should see the "delete" button
  And I should see "bar" within "li#bar"
  And I should see the "delete" button
  And I should see "Add New Page"
  
@create_new_page_root_page
Scenario: Create a new page
  When I go to the admin pages page
  And I follow "Add New Page"
  Then I should be on the new admin page page
  And I fill in "page_title" with "foobar" 
  And I fill in "page_meta_data_title" with "meta_title_foobar"
  And I fill in "page_meta_data_keywords" with "meta_keywords_foobar"
  And I fill in "page_meta_data_description" with "meta_description_foobar" 
  And I check "editor_id_ak730" 
  And I check "editor_id_foo"
  And I select "app" from "page_layout_id" 
  And I select "published" from "page_current_state_attributes_name" 
  And I fill in "page_page_parts_attributes_0_name" with "content" 
  And I select "markdown" from "page_page_parts_attributes_0_filter" 
  And I fill in "page_page_parts_attributes_0_content" with "Hello, World!" 
  And I press "Create Page" 
  Then I should be on the admin pages page
  And I should see "Successfully created page foobar"
  And I should see "foobar" 
  And I should see "published" 
  And I should see the "delete" button
  
@edit_a_existing_page
Scenario: Edit a page
  Given these pages exist in the site "foobar" created by user "ak730"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     |
  When I go to the admin pages page
  And I follow "foobar"
  Then I should now be editing the page "foobar"
  And I fill in "page_meta_data_title" with "meta_title_foobar"
  And I fill in "page_meta_data_keywords" with "meta_keywords_foobar"
  And I fill in "page_meta_data_description" with "meta_description_foobar" 
  And I check "editor_id_ak730" 
  And I check "editor_id_cds27"
  And I select "app" from "page_layout_id" 
  And I select "draft" from "page_current_state_attributes_name" 
  And I fill in "page_page_parts_attributes_0_name" with "content" 
  And I select "markdown" from "page_page_parts_attributes_0_filter" 
  And I fill in "page_page_parts_attributes_0_content" with "Hello, World!" 
  And I press "Update Page"
  Then I should be on the admin pages page
  And I should see "Successfully updated the page foobar"
  And I should see "foobar" 
  And I should see "draft" 
  And I should see the "delete" button
  When I edit the page "foobar"
  Then I should now be editing the page "foobar"
  And the "editor_id_cds27" checkbox should be checked
  And the "page_page_parts_attributes_0_content" field should contain "Hello, World!"
  
@delete_page
Scenario: Delete page as an admin
  Given these pages exist in the site "foobar" created by user "ak730"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     |
  When I go to the admin pages page
  And I press "delete" within "li#foobar"
  Then I should see "Successfully deleted the page foobar"
  And I should be on the admin pages page
  