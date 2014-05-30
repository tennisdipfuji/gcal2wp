begin
  require_relative "secret_keys"
rescue LoadError
  GOOGLE_API_KEY = ENV['GOOGLE_API_KEY']
  ACCESS_TOKEN = ENV['ACCESS_TOKEN']
end
