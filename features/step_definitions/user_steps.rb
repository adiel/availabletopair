

def ensure_user(username,contact = 'cucumber')
  user = User.find(:all, :conditions => ["username = :username", {:username => username}])[0]
  if user.nil?
    user = User.new(:username => username,
                          :password => 'cucumber',
                          :password_confirmation => 'cucumber',
                          :contact => contact,
                          :email => "#{username}@example.com")
  end
  user.contact = contact
  user.confirm!
  user.save!
  user
end

Given /^a user "([^\"]*)"$/ do |username|
  ensure_user(username)
end

When /^(?:I )?visit "([^\"]*)"(?: again)?$/ do |path|
  visit path
end

When /check the published date of the feed entry at position (\d*)$/ do |entry_position|
  published_text = AtomHelper.published_text(page.body,entry_position)
  published_text.should_not eql("")
  @published_dates ||= {}
  @published_dates[entry_position] = Time.parse(published_text)
end


When /^I log in as "([^\"]*)"$/ do |username|
  ensure_user(username)
  When "I am on the homepage"
  And %{I follow "Login"}
  And %{I fill in "Username" with "#{username}"}
  And %{I fill in "Password" with "cucumber"}
  And %{I press "Sign in"}
  When "I am on the homepage"
end

When /^I log out$/  do
  And %{I follow "Logout"}
end

Then /^My path should be "([^\"]*)"$/ do |path|
  URI.parse(current_url).path.should == path
end

Then /^I (?:should )?see the following feed entries:$/ do |table|
  doc = Nokogiri::XML(page.body)
  entries = doc.xpath('/xmlns:feed/xmlns:entry')
  entries.length.should eql(table.rows.length)
  entries.each_with_index do |entry, index|
    entry.xpath("xmlns:title").text.should match(table.rows[index][0])
  end
end

Then /^I should see the following feed entries with content:$/ do |table|
  doc = Nokogiri::XML(page.body)
  entries = doc.xpath('/xmlns:feed/xmlns:entry')
  entries.length.should eql(table.rows.length)
  entries.each_with_index do |entry, index|
    entry.xpath("xmlns:title").text.should match(table.rows[index][0])
    content = entry.xpath("xmlns:content").text
    content_html = Nokogiri::HTML(content)
    content_html.text.should =~ /#{table.rows[index][1]}/
  end
end

Then /^The only entry's content should link to availability page from time period$/ do
  doc = Nokogiri::XML(page.body)
  entries = doc.xpath('/xmlns:feed/xmlns:entry')

  only_availability = Availability.find(:all)[0]
  expected_link_text = "#{only_availability.start_time.strftime("%a %b %d, %Y %H:%M")}-#{only_availability.end_time.strftime("%H:%M")} GMT"
                        
  content = entries[0].xpath("xmlns:content").text
  content.should match(/<a href="http:\/\/www.example.com\/availabilities\/#{only_availability.id}">#{expected_link_text}<\/a>/)
end

Then /^the feed should have the following properties:$/ do |table|
  doc = Nokogiri::XML(page.body)
  table.rows.each do |row|
    doc.xpath("/xmlns:feed/xmlns:#{row[0]}").text.should eql(row[1])
  end
end

Then /^the feed should have the following links:$/ do |table|
  doc = Nokogiri::XML(page.body)
  table.rows.each do |row|
    link = doc.xpath("/xmlns:feed/xmlns:link[@href = '#{row[0]}']")
    link.length.should eql(1)
    link.xpath("@rel").text.should eql(row[1])
  end
end

Then /^the feed should have the following text nodes:$/ do |table|
  doc = Nokogiri::XML(page.body)
  table.rows.each do |row|
    doc.xpath(row[0]).text.should eql(row[1])
  end
end

When /(?:I )?touch the availability at position (\d*) of the feed$/ do |entry_position|
  id = AtomHelper.entry_id(page.body,entry_position)
  sleep 1 # to make sure the new updated_at is different
  Availability.find(id).touch
end

Then /the published date of the entry at position (\d*) has been updated$/ do |entry_position|
  published = Time.parse(AtomHelper.published_text(page.body,entry_position))
  @published_dates[entry_position].should < published
  Time.now.should >= published
end

Then /the published date of the entry at position (\d*) is in xmlschema format$/ do |entry_position|
  published_text = AtomHelper.published_text(page.body,entry_position)
  published_text.should eql(Time.parse(published_text).xmlschema)
end


Then /^the feed should show as updated at the published time of the entry at position (\d*)$/ do |entry_position|
  doc = Nokogiri::XML(page.body)
  published = AtomHelper.published_text(doc,entry_position)
  doc.xpath("/xmlns:feed/xmlns:updated").text.should eql(published)   
end

Then /^the title of the entry at position (\d*) should contain the updated time$/ do |entry_position|
  doc = Nokogiri::XML(page.body)
  published = Time.parse(AtomHelper.published_text(doc,entry_position))
  doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:title").text.should match(/#{published.strftime("%a %b %d, %Y %H:%M")}/)
end

Then /^the id of the entry at position (\d*) should contain the updated time$/ do |entry_position|
  doc = Nokogiri::XML(page.body)
  published = Time.parse(AtomHelper.published_text(doc,entry_position))
  doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:id").text.should match(/\/#{published.xmlschema}/)
end

Then /^the id of the entry at position (\d*) should contain the availability id$/ do |entry_position|
  doc = Nokogiri::XML(page.body)
  id = AtomHelper.entry_id(doc,entry_position)
  doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:id").text.should match(/\/#{id}\//)
end

Then /^I reduce the end time of the availability at position (\d*) of the feed by (\d*) mins?$/ do |entry_position,extend_by|
  id = AtomHelper.entry_id(page.body,entry_position)
  availabilty = Availability.find(id)
  availabilty.end_time -= (extend_by.to_i * 60)
  sleep 2 #make sure the updated_at is changed
  availabilty.save
end

Then /^I extend the end time of the availability at position (\d*) of the feed by (\d*) mins?$/ do |entry_position,extend_by|
  id = AtomHelper.entry_id(page.body,entry_position)
  availabilty = Availability.find(id)
  availabilty.end_time += (extend_by.to_i * 60)
  sleep 2 #make sure the updated_at is changed
  availabilty.save
end

Then /^I reduce the start time of the availability at position (\d*) of the feed by (\d*) mins?$/ do |entry_position,extend_by|
  id = AtomHelper.entry_id(page.body,entry_position)
  availabilty = Availability.find(id)
  availabilty.start_time -= (extend_by.to_i * 60)
  sleep 2 #make sure the updated_at is changed
  availabilty.save
end

Then /^I extend the start time of the availability at position (\d*) of the feed by (\d*) mins?$/ do |entry_position,extend_by|
  id = AtomHelper.entry_id(pag.body,entry_position)
  availabilty = Availability.find(id)
  availabilty.start_time += (extend_by.to_i * 60)
  sleep 2 #make sure the updated_at is changed
  availabilty.save
end