# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def http_root
    'http://' + request.env["HTTP_HOST"]
  end
  
end
