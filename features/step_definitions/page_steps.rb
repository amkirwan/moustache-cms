Given /^these pages exist$/ do |table|
  table.hashes.each do |hash|
    Page.make!(:title => hash[:title])
  end
end

Given /^these current states exist$/ do  |table|
  table.hashes.each do |hash|
    CurrentState.make!(:name => hash[:name])
  end
end