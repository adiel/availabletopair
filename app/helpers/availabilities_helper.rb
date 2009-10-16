module AvailabilitiesHelper
  def contact_link(availability)
    email?(availability.contact) ? mail_to(h(availability.contact)) : link_to(h(availability.contact),h(availability.contact))
  end

  def project_link(availability)
    http?(availability.project) ? link_to(h(availability.project),h(availability.project)) : display_project(availability)
  end

  def http?(url)
    url =~ /^http:\/\//
  end
  
  def email?(url)
    url =~ /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  def display_duration(availability)
    "#{(availability.duration_sec / 3600).floor}h #{((availability.duration_sec % 3600) / 60).to_i}m"
  end

  def display_date_time(time)
    time.strftime("%a %b %d, %Y %H:%M")
  end

  def display_time(time)
    time.strftime("%H:%M")
  end

  def display_when(availability)
    "#{display_date_time(availability.start_time)} - #{display_time(availability.end_time)}"
  end

  def display_project(availability)
    availability.project.to_s == "" ? "anything" : availability.project
  end

  def pairs_link(availability)
    availability.pairs.length == 0 ? "No" : link_to("Yes", availability) + "(#{availability.pairs.length})"
  end
end

