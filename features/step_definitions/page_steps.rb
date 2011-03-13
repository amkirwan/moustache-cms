Given /^these pages exist with current state$/ do |table|
  table.hashes.each do |hash|
    Page.make!(:title => hash[:title], :current_state => CurrentState.make(:name => hash[:status]))
  end
end

Given /^these current states exist$/ do  |table|
  table.hashes.each do |hash|
    CurrentState.make(:name => hash[:name])
  end
end