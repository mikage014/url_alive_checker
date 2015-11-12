require 'net/http'
require 'uri'
require 'yaml'
require 'slack'

def fetch(uri_str, username = nil, password = nil, limit = 10)
  # You should choose better exception.
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  uri = URI.parse(uri_str)
  req = Net::HTTP::Get.new(uri)
  req.basic_auth(username, password)

  response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
    http.request(req)
  }

  case response
  when Net::HTTPSuccess
    response
  when Net::HTTPRedirection
    fetch(response['location'], limit - 1)
  else
    response.value
  end
end

# Read Config
yaml = YAML.load_file("sites.yml")
# URLs
sites = yaml['sites']
# Slack
Slack.configure do |config|
  config.token = yaml['slack_token']
end

messages = []
sites.each do |site|
  begin
    response = fetch(site['url'], site['username'], site['password'])
    #p "#{site['url']} #{response.code}"
    raise if response.code != "200"
  rescue Exception => ex
    msg = "Error #{site['url']} #{ex}"
    messages.push(msg)
  end
end

# notify to slack if error
unless messages.empty?
  text = messages.join("\n")
  Slack.chat_postMessage(text: text, channel: yaml['slack_channel'], username: "URL Alive Checker")
end
