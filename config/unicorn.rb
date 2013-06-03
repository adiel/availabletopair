worker_processes 1
preload_app true
timeout 30
listen 3000

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end