module AvailabilitiesHelper
  
  def link_to_http(text)
    http?(text) ? link_to(h(text)) : h(text)
  end

  def link_to_email_or_http(text)
    email?(text) ? mail_to(h(text)) : link_to_http(text)
  end

  def contact_link(availability)
      link_to_email_or_http( availability.contact)
  end

  def project_link(availability)
    http?(availability.project) ? link_to(h(availability.project),h(availability.project)) : display_project(availability)
  end

  def http?(url)
    url =~ /^https?:\/\//
  end
  
  def email?(url)
    url =~ /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  def display_duration(availability,pad_hours = false)
    format = pad_hours ? "%02dh %02dm" : "%dh %02dm"
    format % [(availability.duration_sec / 3600).floor, ((availability.duration_sec % 3600) / 60).to_i]
  end

  def display_date_time(time)
    time.strftime("%a %b %d, %Y %H:%M")
  end

  def display_time(time)
    time.strftime("%H:%M")
  end

  def display_when(availability)
    "#{display_date_time(availability.start_time)}-#{display_time(availability.end_time)} GMT"
  end

  def display_when_time(availability)
    "#{display_time(availability.start_time)} to #{display_time(availability.end_time)}"
  end

  def display_project(availability)
    availability.project.to_s == "" ? "anything" : availability.project
  end

  def pairs_link(availability)
    availability.pairs.length == 0 ? "No" : link_to("Yes", availability) + "(#{availability.pairs.length})"
  end

  def pairs_updated(availability)
    availability.pairs.length > 0 ? availability.pairs[0].updated_at : availability.updated_at
  end

  def pair_status(pair)
    if (!pair.accepted && !pair.suggested)
      return :open
    elsif (pair.accepted && pair.suggested)
      return :paired
    else
      :suggested
    end
  end

  def build_suggested_status(pair)
    if (pair.accepted)
      user = current_user_accepted(pair) ? "You" : pair.availability.user.username
    else
      user = current_user_suggested(pair) ? "You" : pair.user.username
    end
    "#{user} suggested pairing"
  end

  def display_pair_status(pair)
    status = pair_status(pair)
    case(status)
      when :open
        "Open"
      when :paired
        "Paired"
      when :suggested
        build_suggested_status(pair)
    end
  end

  def button_to_suggest_accept(pair)
    if (pair.accepted)
      action = "cancel"
      text = pair.suggested ? "Cancel pairing" : "Cancel"
    else
      action = "suggest"
      text = pair.suggested ? "Accept" : "Suggest pairing"
    end
    button_to(text, {:controller => 'pairs', :action => action, :id => pair.id}, :method => :post)
  end
  
  def display_tags(availability)
	if availability.tags.length == 0
      'none'
    else
      tag_links = []
      tags = availability.tags.sort_by{|t|t.tag}
      tags.each do|t|
        tag_links << link_to(h(t.tag),"#{http_root}/tags/#{CGI::escape(t.tag)}")
      end
      tag_links.join(', ')
    end

  end

  private

  def current_user_accepted(pair)
    return (!current_user.nil? && pair.availability.user_id == current_user.id)
  end

  def current_user_suggested(pair)
    return (!current_user.nil? && pair.user_id == current_user.id)
  end
end

