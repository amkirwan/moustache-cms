Given /^these pages exist with current state$/ do |table|
  root_page = Factory(:root_page)
  table.hashes.each do |hash|
    Factory(:no_root_page, :parent_id => root_page.id, :title => hash[:title], :current_state => Factory.build(:current_state, :name => hash[:status]))
  end
end

Given /^these current states exist$/ do  |table|
  table.hashes.each do |hash|
    Factory.build(:current_state, :name => hash[:name])
  end
end