When /^I visit "([^\"]*)"$/ do |path|
  visit path
end

Then /^My path should be "([^\"]*)"$/ do |path|
  puts path
  puts URI.parse(current_url).path
  URI.parse(current_url).path.should == path
end

