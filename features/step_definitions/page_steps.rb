Given /^these pages exist$/ do |table|
  table.hashes.each do |hash|
    Page.make!(:title => hash[:title], :current_state => CurrentState.make!(:name => hash[:state]))
  end
end