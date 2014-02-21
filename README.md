gcal2wp
=======

post to Wordpress.com the event acquired from Google Calendar

* Googleカレンダーのイベント情報を取得してHTML化(gcal2html.rb)
* Wordpress.comへの投稿(post2wp.rb)

以上を行うスクリプト群


Usage
-----

    $ bundle exec ruby gcal2html.rb | bundle exec ruby post2wp.rb

Reference
---------

Wordpress.comのREST APIで投稿済みエントリーを更新してみる
http://qiita.com/ma2shita/items/93f38e5f783083e88455

`oauth2.rb`の使い方は上記にて。

