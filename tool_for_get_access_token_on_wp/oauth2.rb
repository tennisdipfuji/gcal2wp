require 'sinatra'
require 'net/http'
require 'uri'
require "#{File.dirname(__FILE__)}/../secret_keys"

bd = {client_id: CLIENT_ID, client_secret: CLIENT_SECRET, redirect_uri: REDIRECT_URI}

get '/' do
  "https://public-api.wordpress.com/oauth2/authorize?client_id=#{bd[:client_id]}&redirect_uri=#{bd[:redirect_uri]}&response_type=code"
end

get '/oauth2' do
  bd.merge!(code:params[:code], grant_type:'authorization_code').to_s
  uri = URI.parse('https://public-api.wordpress.com/oauth2/token?pretty=1')
  req = Net::HTTP::Post.new(uri.request_uri)
  req.set_form_data(bd)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.set_debug_output $stderr
  res = http.start{|h| h.request(req)}
  res.body
end

