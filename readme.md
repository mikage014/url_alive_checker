URL Alive Checker
====

URLのHTTPステータスを監視して200以外のときSlackに通知します
URLを複数監視する場合でも1回の起動につき1POSTにまとめて通知します

[whenever](https://github.com/javan/whenever)を使ってcronで起動します

HTTP, HTTPSに対応
Basic Authenticationに対応

## Installation

```
$ git clone https://github.com/mikage014/url_alive_checker.git
```

## Setting sites.yml

[ここ](https://api.slack.com/web)からSlackのAPIトークンを取得して``slack_token``にセットします
``slack_channel``に通知先のチャンネルをセットします

```yaml
slack_token: slack_token_here
slack_channel: slack_channel_here
sites:
  - url: http://www.example.com/
  - url: https://www.example.com/
  - url: http://www.basic-authentication-example.com/
    username: user
    password: pass
```

## Setting config/schedule.rb

wheneverの書式で時刻を設定します

カレントディレクトリに移動して``url_alive_checker.rb``を起動します

rubyコマンドはパスを通すか、フルパスで指定します
例）8時から20時までの間、毎時0分、30分にチェックを行います

```ruby
every '0,30 8-20 * * *' do
  command 'cd /path/to/url_alive_checker; ruby url_alive_checker.rb'
end
```

## crontabへの追加
``$ whenever --update-crontab`` でcrontabに反映させます

