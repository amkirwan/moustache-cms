Feature: Admin Pages Management Features

@index_page_view
Scenario: Navigate to the Pages#index page
  Given I login as "ak730" with the role of "admin"
  And these pages exist
  | title  | state     |
  | foobar | Published |
  | bar    | Draft     |
  When I go to the admin pages page
  Then I should be on the admin pages page
  And I should see "foobar" within "tr#foobar"
  And I should see "Published" within "tr#foobar"
  And I should see "delete" button within "tr#foobar"
  And I should see "bar" within "tr#bar"
  And I should see "Draft" within "tr#bar"
  And I should see "delete" button within "tr#bar"
  And I should see "Add New Page"