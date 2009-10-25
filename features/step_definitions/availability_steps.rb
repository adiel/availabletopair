Given /^no availabilities in the system$/ do
  Pair.delete_all
  Availability.delete_all
end

Given /^only the following availabilities in the system$/ do |table|
  Given "no availabilities in the system"
  table.rows.each do |row|
    Availability.create(:developer => row[0], :project => row[1], :start_time => row[2], :end_time => row[3], :contact => row[4])
  end
end

Given /^the following availabilities in the system with an end time (\d*) minutes? in the past:$/ do |mins,table|
  table.rows.each do |row|
    a = Availability.create(:developer => row[0], :project => row[1], :contact => 'asdf', :start_time => Time.now.utc - 120, :end_time => Time.now.utc - (60 * mins.to_i))
  end
end

Given /^the following availabilities in the system with an end time (\d*) minutes? in the future:$/ do |mins,table|
  table.rows.each do |row|
    a = Availability.create(:developer => row[0], :project => row[1], :contact => 'asdf',:start_time => Time.now.utc - 60, :end_time => Time.now.utc + (60 * mins.to_i))
  end
end


Then /^I should see the following availabilites listed in order$/ do |table|

  table.rows.each_with_index do |row,index|
    row_selector = ".availabilities tr:nth-child(#{index + 2})"
    Then "I should see \"#{row[0]}\" within \"#{row_selector} td:nth-child(1)\""
    Then "I should see \"#{row[1]}\" within \"#{row_selector} td:nth-child(2)\""
    Then "I should see \"#{row[2]}\" within \"#{row_selector} td:nth-child(3)\""
    Then "I should see \"#{row[3]}\" within \"#{row_selector} td:nth-child(4)\""
    Then "I should see \"#{row[4]}\" within \"#{row_selector} td:nth-child(5)\""
    
  end

end

Then /^I should see the following matching pairs$/ do |table|

  table.rows.each_with_index do |row,index|
    row_selector = ".pair tr:nth-child(#{index + 2})"
    Then "I should see \"#{row[0]}\" within \"#{row_selector} td:nth-child(1)\""
    Then "I should see \"#{row[1]}\" within \"#{row_selector} td:nth-child(2)\""
    Then "I should see \"#{row[2]}\" within \"#{row_selector} td:nth-child(3)\""
    Then "I should see \"#{row[3]}\" within \"#{row_selector} td:nth-child(4)\""
  end

end


