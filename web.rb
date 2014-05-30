require "sinatra"
require "yaml"
require "#{File.dirname(__FILE__)}/lib/gcal"
require "#{File.dirname(__FILE__)}/lib/post2wp"

get "/" do
  erb :index
end

get "/robots.txt" do
  content_type "text/plain"
  <<-EOT
User-agent: *
Disallow: /
  EOT
end

get "/favicon.ico" do
  status 404
  "No Provide."
end

get "/get" do
  @y = Gcal.get.to_yaml
  erb :get
end

get "/update" do
  Post2Wp.run(Gcal.get.to_html)
  erb :update
end

__END__
@@ layout
<%= yield %>

@@ index
<ul>
  <li><a href="/update">update</a></li>
  <li><a href="/get">get</a></li>
</ul>

@@ get
<textarea>
<%= @y %>
</textarea>

@@ update
<a href="http://tennisdipfuji.wordpress.com/schedule/">Schedule Page</a>
