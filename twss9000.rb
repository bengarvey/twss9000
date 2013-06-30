# twss9000 
# Ben Garvey
# ben@bengarvey.com
# http://www.bengarvey.com
# @bengarvey
# 6/30/2013
#
# A twitter bot that searches for twss or "that's what she said" and RT's the parent tweet

require 'rubygems'
require 'Twitter'
require 'yaml'

settings = YAML.load_file("config.yml")
conf = settings['config']

Twitter.configure do |config|
  config.consumer_key       = conf['consumer_key']
  config.consumer_secret    = conf['consumer_secret']
  config.oauth_token        = conf['oauth_token']
  config.oauth_token_secret = conf['otath_token_secret']
end

parentIds = Array.new
searchText = "#twss"

Twitter.search(searchText, :count => 20, :result_type => "recent").results.map do |status|
  parentIds.push(status.in_reply_to_status_id)
end

parentIds.each do |id|
  if !id.nil?
    status = Twitter.status(id)
    puts "\n#{status.from_user}: #{status.text}"
  end
end



