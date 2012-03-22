def find_page_by_title(title)
  Page.where(:title => title, :site_id => @site.id).first
end

def page_id_selector(page)
  '#' + "#{page.title.parameterize}_#{page.id}"
end

def page_part_id(pp_name)
  @page.page_parts.where(:name => pp_name).first.id.to_s
end

def page_part_selected(selected_id)
  find("#page_part_" + selected_id).should be_visible # selected page part should show
  page.should have_xpath("//li[@class='tab selected' and @id='#{selected_id}_nav']")  # correct tab is selected
end

def page_part_not_selected(pp_id)
  find("#page_part_" + pp_id).should_not be_visible # other page part should be hidden
  page.should_not have_xpath("//li[@class='tab selected' and @id='#{pp_id}_nav']") 
end

def page_part_nav(tabs)
  page_part_selected(tabs[:selected])
  tabs[:other_tabs].each do |tab_id|
    page_part_not_selected(tab_id)
  end
end

Given /^these pages exist$/ do |table|
  table.hashes.each do |hash|
    create_page(hash[:title], hash[:status])
  end
end

Given /^I view the pages in the site$/ do
  visit '/admin/pages'
end

Given /^I want to create a new page in the site$/ do
  step %{I view the pages in the site}
  click_link 'New Page'
end

Given /^the page "([^"]*)" has a child page "([^"]*)"$/ do |parent_title, child_title|
  @page = find_page_by_title(parent_title)
  @child_page = create_child_page(child_title, 'published', @page)
end

When /^I create a page with the title "([^"]*)"$/ do |title|
  fill_in 'Title*', :with => title
  select @layout.name, :from => 'Layout*'
  select 'draft', :from => 'Status*'
  select 'markdown', :from => 'Filter*'
  click_button 'Create Page'
end

When /^I change the page title of "([^"]*)" to "([^"]*)"$/ do |title_from, title_to|
  click_link title_from
  fill_in 'Title*', :with => title_to
  click_button 'Update Page'
end

When /^I show "([^"]*)"'s child pages$/ do |parent_title|
  @page = find_page_by_title(parent_title)
  find(page_id_selector(@page)).find('.page_fold_arrow').click
end 

When /^I hide the child page "([^"]*)"$/ do |child_title|
  @child_page = find_page_by_title(child_title)
  @parent_page = @child_page.parent
  step %{I show "#{@parent_page.title}"'s child pages}
  step %{then "#{@child_page.title}" should be expanded in the view}
  find(page_id_selector(@parent_page)).find('.page_fold_arrow').click
end

When /^I delete the page "([^"]*)"$/ do |title|
  click_link title
  click_link 'Delete Page'
end

When /^I delete the page "([^"]*)" from the pages list$/ do |title|
  @page = find_page_by_title(title)
  find(".delete_#{@page.title.parameterize('_')}").click # find delete div
  page.driver.browser.switch_to.alert.accept
end

When /^I delete the page "([^"]*)" from the pages list that has a child page then I should need to double confirm the delete$/ do |parent_title|
  find(".delete_#{@page.title.parameterize('_')}").click # find delete div
  page.driver.browser.switch_to.alert.accept
  page.driver.browser.switch_to.alert.accept
end

When /^I move the "([^"]*)" to come before "([^"]*)"$/ do |page_to_move, target_page|
  @page = find_page_by_title(page_to_move)
  page.execute_script %Q{
    var element_id = $('ol.pages li').last().attr('id');
    $('#' + element_id).simulateDragSortable({move: -2, handle: 'em.sortable_list'});
  } 
end

When /^I edit the page "([^"]*)"$/ do |page_title|
  @page = find_page_by_title(page_title)
  step %{I view the pages in the site}
  click_link page_title
end

When /^I edit the page "([^"]*)" with an additional page part baz$/ do |page_title|
  @page = find_page_by_title(page_title)
  @page.page_parts << Factory.build(:page_part, :name => 'baz', :filter_name => 'markdown')
  step %{I edit the page "#{page_title}"}
end

When /^I change the page part name to "([^"]*)"$/ do |name_to|
  fill_in 'Page Part Name*', :with => name_to
  select 'textile', :from => 'Filter*' # need to lose focus to change nav name
end

When /^I add a page part$/ do
  click_link('Add Page Part')
  wait_for_ajax
end

When /^I edit the page part (.*)$/ do |part_title|
  click_link part_title
  wait_for_ajax
end

When /^I delete the page part baz$/ do
  step %{I edit the page part baz}
  click_link 'Delete'
  dialog_ok
end

Then /^then "([^"]*)" should be expanded in the view$/ do |child_title|
  page.should have_content child_title
end

Then /^then "([^"]*)" should not be expanded within "([^"]*)"$/ do |child_title, parent_title|
  @parent_page = find_page_by_title(parent_title)
  wait_for_ajax
  find(page_id_selector(@parent_page) + " ol.pages").should_not be_visible
end

Then /^I should see the pages listed$/ do 
  @site.pages.each do |site_page|
    steps %{Then I should see "#{site_page.title}" in the pages list}
  end
end

Then /^I should see "([^"]*)" in the pages list$/ do |title|
  path_should_be admin_pages_path
  page.should have_content title
end

Then /^the page should be removed from the pages list$/ do 
  sleep 1
  page.should_not have_selector(page_id_selector(@page))
end

Then /^page part nav tab should show "([^"]*)"$/ do |nav_name|
  page.should have_content nav_name
end

Then /^it should be added to the page$/ do
  @page = find_page_by_title(@page.title)
  pp_id = page_part_id 'page part 2'
  page.should have_content 'page part 2' # new page part default name
  find("#page_part_" + pp_id).should be_visible # selected page part should show
  page.should have_xpath("//li[@class='tab selected' and @id='#{pp_id}_nav']")  # correct tab is selected
end

Then /^it should be the selected page part$/ do
  foobar_id = page_part_id 'foobar'
  baz_id = page_part_id 'baz'
  page_part_selected(baz_id)
  page_part_not_selected(foobar_id)
end

Then /^the page part baz should be removed from the page$/ do
  page.should_not have_content 'baz'
end

Then /^I can switch between the page parts in the page part navigation tabs$/ do
  @page = find_page_by_title(@page.title)
  foobar_id = page_part_id 'foobar'
  baz_id = page_part_id 'baz'
  pp_id = page_part_id 'page part 3'

  page_part_nav(:selected => pp_id, :other_tabs => [foobar_id, baz_id])

  click_link 'foobar'
  wait_for_ajax
  page_part_nav(:selected => foobar_id, :other_tabs => [pp_id, baz_id])

  click_link 'baz'
  wait_for_ajax
  page_part_nav(:selected => baz_id, :other_tabs => [pp_id, foobar_id])
  
  click_link 'page part 3'
  wait_for_ajax
  page_part_nav(:selected => pp_id, :other_tabs => [foobar_id, baz_id])
end
