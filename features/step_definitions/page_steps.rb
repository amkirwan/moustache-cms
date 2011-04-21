Given /^these pages exist with current state$/ do |table|
  user = Factory(:user)
  layout = Factory(:layout, :created_by => user, :updated_by => user)
  site = Factory(:site) 
  parent = Factory(:page, :site => site, :layout => layout, :created_by => user, :updated_by => user)
  table.hashes.each do |hash|
    Factory(:page, :parent => parent, 
                   :layout => layout,
                   :created_by => user,
                   :updated_by => user,
                   :title => hash[:title], 
                   :current_state => Factory.build(:current_state, :name => hash[:status]))
  end
end

Given /^these current states exist$/ do  |table|
  table.hashes.each do |hash|
    Factory.build(:current_state, :name => hash[:name])
  end
end