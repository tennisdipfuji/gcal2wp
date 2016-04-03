require 'net/http'
require 'uri'
require 'time'
require_relative "load_secret"

module Post2Wp
  TOKEN_TYPE = 'bearer'
  SITE = 'tennisdipfuji.wordpress.com'

  def self.run(post_content, post_id = 98, post_date = Time.now)
    bd = {content: post_content, date: post_date.iso8601}
    uri = URI.parse("https://public-api.wordpress.com/rest/v1/sites/#{SITE}/posts/#{post_id}?pretty=1")
    req = Net::HTTP::Post.new(uri.request_uri)
    req['authorization'] = "#{TOKEN_TYPE} #{ACCESS_TOKEN}"
    req.set_form_data(bd)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.set_debug_output STDERR
    res = http.start{|h| h.request(req)}
    res.body
  end
end
