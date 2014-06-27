Then /^the specs should pass$/ do
  run_simple('bin/rspec')
end

Then /^the features should pass$/ do
  run_simple('bin/cucumber')
end
