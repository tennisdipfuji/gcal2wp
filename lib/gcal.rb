require 'rubygems'
require 'open-uri'
require 'time'
require 'erb'
require 'cgi'
require 'json'
require_relative "secret_keys"

class Time
	def goodfmt(f = true)
		%w(日 月 火 水 木 金 土)
		a = self.to_a
		s = self.strftime("#{a[2]}:%M")
		s = (s == '0:00') ? '' : s
		s = sprintf('%s/%s (%s) %s', a[4], a[3], %w(日 月 火 水 木 金 土)[a[6]].coloring_in_html, s) if f
		s
	end
end

class String
	def coloring_in_html
		case self
		when '土'
			"<span style=\"color:#007bbb\">#{self}</span>"
		when '日'
			"<span style=\"color:#d00\">#{self}</span>"
		else
			self
		end
	end
end

class Array
  def to_html
    @c = self
    tpl = open("#{File.dirname(__FILE__)}/tpl.erb.html")
    ERB.new(tpl.read, nil, '%').result(binding)
  end
end

module Gcal
  def self.get(q = "練習", start_at = Time.now)
    u = "https://www.googleapis.com/calendar/v3/calendars/tennisdipfuji%40gmail.com/events?orderBy=startTime&q=#{CGI.escape(q)}&singleEvents=true&timeMin=#{CGI.escape(start_at.iso8601)}&timeZone=Asia%2FTokyo&key=#{GOOGLE_API_KEY}"
    c = JSON.parse(open(u).read)['items'].inject(Array.new) do |a, i|
      a << {:tl => i['summary'].sub(/^【.+】/, ''),
        :st => Time.parse(i['start']['dateTime'] || i['start']['date']),
        :en => Time.parse(i['end']['dateTime'] || i['start']['date']),
        :mp => ("http://maps.google.co.jp/maps?hl=ja&q=#{CGI.escape(i['location'])}" rescue ''),
        :pl => (i['location'].match(/^[0-9.]+,[0-9.]+\((.+)\)/)[1] rescue i['location'] || ''),
        :cn => i['description'].strip,
        :mh => Time.parse(i['start']['dateTime'] || i['start']['date']).to_a[4]
        }
	    a
    end
    c.sort!{|a,b| a[:st] <=> b[:st]}
  end
end
