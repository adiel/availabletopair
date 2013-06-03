# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def http_root
    'http://' + request.env["HTTP_HOST"].gsub(/\:\d+/,'')
  end

  def mine? (availability)
    !current_user.nil? && current_user.id == availability.user_id
  end
  
end
