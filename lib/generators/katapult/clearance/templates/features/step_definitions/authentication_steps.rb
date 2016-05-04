When /^I (?:am signed|sign) in as the user above$/ do
  user = User.last!
  visit root_path(as: user) # Using Clearance::BackDoor
end
