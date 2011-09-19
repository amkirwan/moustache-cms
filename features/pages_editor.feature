Feature: Admin Pages Management Features

Background: Login create default site
Given the site "foobar" exists with the domain "example.com"
And the user "ak730" exists with the role of "admin" in the site "foobar.example.com"
And these current states exist
| name      |
| published |
| draft     |
And these layouts exist in the site "foobar.example.com" created by user "ak730"
| name | content              |
| app  | Hello, World         |
| baz  | Hello, <b>World!</b> |
And the user with the role exist
 | user  | role   | site               |
 | foo   | admin  | foobar.example.com |
 | bar   | editor | foobar.example.com |
 | cds27 | editor | foobar.example.com |
And I authenticates as cas user "cds27"

@editor_can_see_page_index_page
Scenario: Given I am logged in as an editor then I can see the pages
  Given these pages exist in the site "foobar.example.com" created by user "cds27"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     | 
  When I go to the admin pages page
  Then I should be on the admin pages page 
  And I should see "foobar" within "li#foobar"
  And I should see the delete image "delete_button.png" in "li#foobar"
  And I should see "bar" within "li#bar"
  And I should see the delete image "delete_button.png" in "li#bar"
  And I should see "New Page"
  
@create_new_page_page
Scenario: Create a new page
  Given these pages exist in the site "foobar.example.com" created by user "ak730"
  | title     | status    | 
  | Home Page | published | 
  When I go to the admin pages page
  And I follow "New Page"
  Then I should be on the new admin page page
  And I select "Home Page" from "page_parent_id"
  And I fill in "page_title" with "foobar" 
  When I fill in "page_meta_tags_attributes_0_content" with "meta_title_foobar"
  And I fill in "page_meta_tags_attributes_1_content" with "meta_keywords_foobar"
  And I fill in "page_meta_tags_attributes_2_content" with "meta_description_foobar" 
  And I check "editor_id_ak730" 
  And I check "editor_id_foo"
  And I select "app" from "page_layout_id" 
  And I select "published" from "page_current_state_attributes_name" 
  And I fill in "page_page_parts_attributes_0_name" with "content" 
  And I select "markdown" from "page_page_parts_attributes_0_filter_name" 
  And I fill in "page_page_parts_attributes_0_content" with "Hello, World!" 
  And I press "Create Page" 
  Then I should be on the admin pages page
  And I should see "Successfully created page foobar"
  And I should see "foobar" 
  
@edit_a_existing_page
Scenario: Edit an existing page the user is an editor of
  Given these pages exist in the site "foobar.example.com" created by user "cds27"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     |
  When I go to the admin pages page
  And I follow "foobar"
  Then I should now be editing the page "foobar"
  When I fill in "page_meta_tags_attributes_0_content" with "meta_title_foobar"
  And I fill in "page_meta_tags_attributes_1_content" with "meta_keywords_foobar"
  And I fill in "page_meta_tags_attributes_2_content" with "meta_description_foobar" 
  And I check "editor_id_ak730" 
  And I check "editor_id_cds27"
  And I select "app" from "page_layout_id" 
  And I select "draft" from "page_current_state_attributes_name" 
  And I fill in "page_page_parts_attributes_0_name" with "content" 
  And I select "markdown" from "page_page_parts_attributes_0_filter_name" 
  And I fill in "page_page_parts_attributes_0_content" with "This is some new text" 
  And I press "Update Page"
  Then I should be on the admin pages page
  And I should see "Successfully updated the page foobar"
  And I should see "foobar" 
  When I edit the page "foobar"
  Then I should now be editing the page "foobar"
  And the "editor_id_cds27" checkbox should be checked
  And the "page_page_parts_attributes_0_content" field should contain "This is some new text"

@delete_page
Scenario: Delete page the user is an editor of
  Given these pages exist in the site "foobar.example.com" created by user "cds27"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     |
  When I go to the admin pages page
  And I follow "Delete" within "li#foobar"
  Then I should see "Successfully deleted the page foobar"
  And I should be on the admin pages page
  

# Actions_Blocked  

@editor_should_not_access_other_site 
Scenario: Should not be able to access site the user is not associated with
  Given the site "baz" exists with the domain "example.dev"
  When I go to the admin pages page
  Then I should see "403"
  
@editor_cannot_edit_a_page_not_editor_of
Scenario: Cannot edit a page the user is not an editor of
  Given these pages exist in the site "foobar.example.com" created by user "ak730"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     |
  When I go to the admin pages page
  And I follow "foobar"
  Then I should see "403"
  
@editor_cannot_delete_page_not_editor_of
Scenario: Cannot delete page the user is an editor of
  Given these pages exist in the site "foobar.example.com" created by user "ak730"
  | title  | status    | 
  | foobar | published | 
  | bar    | draft     |
  When I go to the admin pages page
  Then I should not see the delete image "delete_button.png" in "li#foobar"
  Then I should not see the delete image "delete_button.png" in "li#foobar"

