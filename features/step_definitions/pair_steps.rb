Given /^"([^\"]*)" has suggested pairing with all available pairs$/ do |username|
  user = User.find(:all,:conditions => {:username => username})[0]
  user.availabilities.each do |availability|
    availability.pairs.each do |pair|
      pair.accepted = true
      pair.save
      reciprocal = pair.find_reciprocal_pair
      reciprocal.suggested = true
      reciprocal.save
    end
  end
  sleep 1
end

Given /^"([^\"]*)" has suggested pairing with "([^\"]*)" where possible$/ do |username, pair_username|
  user = User.find(:all,:conditions => {:username => username})[0]
  pair_user = User.find(:all,:conditions => {:username => pair_username})[0]
  user.availabilities.each do |availability|
    availability.pairs.each do |pair|
      if (pair.user_id == pair_user.id)
        pair.accepted = true
        pair.save
        reciprocal = pair.find_reciprocal_pair
        reciprocal.suggested = true
        reciprocal.save
      end
    end
  end
  sleep 1
end

Given /^"([^\"]*)" has suggested pairing with all available pairs except "([^\"]*)"$/ do |username, pair_username|
  user = User.find(:all,:conditions => {:username => username})[0]
  pair_user = User.find(:all,:conditions => {:username => pair_username})[0]
  user.availabilities.each do |availability|
    availability.pairs.each do |pair|
      if (pair.user_id != pair_user.id)
        pair.accepted = true
        pair.save
        reciprocal = pair.find_reciprocal_pair
        reciprocal.suggested = true
        reciprocal.save
      end
    end
  end
  sleep 1
end

Then /^I should see the following pair statuses:$/ do |table|
  table.rows.each_with_index do |row,index|
    row_selector = ".pairs tr:nth-child(#{index + 2})"
    Then "I should see \"#{row[0]}\" within \"#{row_selector} td:nth-child(1)\""
    Then "I should see \"#{row[1]}\" within \"#{row_selector} td:nth-child(7)\""
  end
end
