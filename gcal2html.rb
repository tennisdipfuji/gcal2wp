require 'rubygems'
require 'open-uri'
require 'time'
require 'erb'
require 'optparse'
require 'cgi'
require 'json'
require './secret_keys'

start_at = Time.now.strftime('%Y-%m-%d')
q = '練習'

u = "https://www.googleapis.com/calendar/v3/calendars/tennisdipfuji%40gmail.com/events?orderBy=startTime&q=#{CGI.escape(q)}&singleEvents=true&timeMin=#{CGI.escape(Time.parse(start_at).iso8601)}&timeZone=Asia%2FTokyo&key=#{GOOGLE_API_KEY}"

@c = JSON.parse(open(u).read)['items'].inject(Array.new) do |a, i|
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
@c.sort!{|a,b| a[:st] <=> b[:st]}

class Time
	def goodfmt(f = true)
		%w(日 月 火 水 木 金 土)
		a = self.to_a
		s = self.strftime("#{a[2]}:%M")
		s = (s == '0:00') ? '' : s
		s = sprintf('%s/%s (%s) %s', a[4], a[3], %w(日 月 火 水 木 金 土)[a[6]].color, s) if f
		s
	end
end

class String
	def color
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

ERB.new(DATA.read, nil, '%').run(binding)
__END__
<div style="font-size:1.15em">
<p><a href="/schedule/#respond">コメントはこちらにどうぞ！</a></p>
<p>当日の練習状況などは「<a href="https://twitter.com/TennisDIPFuji">今日の状況(Twitterへ)</a>」で確認することができます！</p>
<p>Googleカレンダーをお使いの方は「<a href="https://www.google.com/calendar/render?cid=tennisdipfuji@gmail.com">テニス倶楽部DIP富士のGoogleカレンダー</a>」で自分のカレンダーに取り込むこともできますよ</p>
<p style="text-align:right;"><%= Time.now.strftime('%m/%d') %>更新</p>
% mhc = 0
% @c.each do |e|
%   unless mhc == e[:mh]
%     unless mhc == 0
</dl>
</div>
%     end
<h2 style="padding:6px;border-bottom:1px solid #aaa;border-left:12px solid #aaa;"><%= e[:mh] %>月</h2>
<div style="margin:1em;">
<dl>
%     mhc = e[:mh]
%     close_flg = true
%   end
<dt><span style="font-size:1.2em;line-height:2em;">■<%= e[:st].goodfmt %> - <%= e[:en].goodfmt(false) %> <span><%= e[:tl] %></span></dt>
  <dd>
    <ul>
% unless e[:pl].empty?
    <li><%= e[:pl] %> <span>(<a href="<%= e[:mp] %>">地図</a>)</span></li>
% else
    <li>別途連絡</li>
% end
    <li><%= e[:cn] %>
    </ul>
  </dd>
% end
</dl>
</div>
<p><a href="https://www.google.com/calendar/render?cid=tennisdipfuji@gmail.com"><img src="http://www.google.com/calendar/images/calendar_plus_en.gif" alt="テニス倶楽部DIP富士 Googleカレンダー" /></a></p>
</div>
