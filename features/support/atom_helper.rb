class AtomHelper

  def self.entry_id(xml,entry_position)
    link = AtomHelper.load(xml).xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:link/@href").text
    /(\d*)$/.match(link)[0]
  end

  def self.published_text(xml,entry_position)
    AtomHelper.load(xml).xpath("/xmlns:feed/xmlns:entry[#{entry_position}]/xmlns:published").text
  end

  def self.load(xml)
    xml.respond_to?("xpath") ? xml : Nokogiri::XML(xml)
  end

end