require "yaml"
require "#{File.dirname(__FILE__)}/lib/gcal"
require "#{File.dirname(__FILE__)}/lib/post2wp"

desc "Get events"
task :get do
  puts Gcal.get.to_yaml
end

desc "Update to Schedule Page"
task :update do
  Post2Wp.run(Gcal.get.to_html)
end
