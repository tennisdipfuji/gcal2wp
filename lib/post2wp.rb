require 'net/http'
require 'uri'
require 'date'
require './secret_keys'

token_type = 'bearer'
site = 'tennisdipfuji.wordpress.com'
post_id = '98'
bd = {content: STDIN.read, date: DateTime.now.iso8601}

uri = URI.parse("https://public-api.wordpress.com/rest/v1/sites/#{site}/posts/#{post_id}?pretty=1")
req = Net::HTTP::Post.new(uri.request_uri)
req['authorization'] = "#{token_type} #{ACCESS_TOKEN}"
req.set_form_data(bd)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
#http.set_debug_output STDERR
res = http.start{|h| h.request(req)}
STDERR.puts res.body

