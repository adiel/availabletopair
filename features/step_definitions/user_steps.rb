When /^(?:I )?visit "([^\"]*)"(?: again)?$/ do |path|
  visit path
end

Then /^My path should be "([^\"]*)"$/ do |path|
  URI.parse(current_url).path.should == path
end

Then /^I (?:should )?see the following feed entries:$/ do |table|
  doc = Nokogiri::XML(response.body)
  entries = doc.xpath('/xmlns:feed/xmlns:entry')
  entries.length.should eql(table.rows.length)
  entries.each_with_index do |entry, index|
    entry.xpath("xmlns:title").text.should match(table.rows[index][0])
  end
end

Then /^I should see the following feed entries with content:$/ do |table|
  doc = Nokogiri::XML(response.body)
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
  doc = Nokogiri::XML(response.body)
  entries = doc.xpath('/xmlns:feed/xmlns:entry')

  only_availability = Availability.find(:all)[0]
  expected_link_text = "#{only_availability.start_time.strftime("%a %b %d, %Y %H:%M")} - #{only_availability.end_time.strftime("%H:%M")}"

  content = entries[0].xpath("xmlns:content").text
  content.should match(/<a href="http:\/\/www.example.com\/availabilities\/#{only_availability.id}">#{expected_link_text}<\/a>/)
end

Then /^the feed should have the following properties:$/ do |table|
  doc = Nokogiri::XML(response.body)
  table.rows.each do |row|
    doc.xpath("/xmlns:feed/xmlns:#{row[0]}").text.should eql(row[1])
  end
end

Then /^the feed should have the following links:$/ do |table|
  doc = Nokogiri::XML(response.body)
  table.rows.each do |row|
    link = doc.xpath("/xmlns:feed/xmlns:link[@href = '#{row[0]}']")
    link.length.should eql(1)
    link.xpath("@rel").text.should eql(row[1]) 
  end
end

Then /^the feed should have the following text nodes:$/ do |table|
  doc = Nokogiri::XML(response.body)
  table.rows.each do |row|
    doc.xpath(row[0]).text.should eql(row[1]) 
  end
end

When /check the published date of the feed entry at position (\d*)$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  published_text = doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:published").text
  published_text.should_not eql("")
  @published_dates ||= {}
  @published_dates[entry_position] = Time.parse(published_text)
end

When /(?:I )?touch the availability at position (\d*) of the feed$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  link = doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:link/@href").text
  id = /(\d*)$/.match(link)[0]
  sleep 1 # to make sure the new updated_at is different
  Availability.find(id).touch
end

Then /the published date of the entry at position (\d*) has been updated$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  published = Time.parse(doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:published").text)
  @published_dates[entry_position].should < published
  Time.now.should >= published
end

Then /the published date of the entry at position (\d*) is in xmlschema format$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  published_text = doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:published").text
  published_text.should eql(Time.parse(published_text).xmlschema)
end


Then /^the feed should show as updated at the published time of the entry at position (\d*)$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  published = doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:published").text
  doc.xpath("/xmlns:feed/xmlns:updated").text.should eql (published)   
end

Then /^the title of the entry at position (\d*) should contain the updated time$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  published = Time.parse(doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:published").text)

  doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:title").text.should match(/#{published.strftime("%a %b %d, %Y %H:%M")}/)
end

Then /^the id of the entry at position (\d*) should contain the updated time$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  published = Time.parse(doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:published").text)

  doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:id").text.should match(/\/#{published.xmlschema}/)
end

Then /^the id of the entry at position (\d*) should contain the availability id$/ do |entry_position|
  doc = Nokogiri::XML(response.body)
  link = doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:link/@href").text
  id = /(\d*)$/.match(link)[0]
  doc.xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:id").text.should match(/\/#{id}\//)
end