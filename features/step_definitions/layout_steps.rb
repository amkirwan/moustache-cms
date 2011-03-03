Given /^the following layouts exist$/ do |table|
  table.hashes.each do |hash|
    Layout.make!(:name => hash[:layout])
  end
end