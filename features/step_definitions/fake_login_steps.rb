def fake_login(puid)
  post fake_cas_login_path, :cas_user => puid
end

Given /^the user (.*)$/ do |user|
  @user = Person.make
end

Given /^cas authenticates with fake login$/ do 
  fake_login(@user.partners_uid)
end

Given /^I login as "([^\"]*)"$/ do |person|
  Given "the user #{person}"
  Given "cas authenticates with fake login"
end 

Given /^I am "([^\"]*)"$/ do |person|
  Given "the user #{person}"  
end
