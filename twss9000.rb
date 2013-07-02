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
  config.oauth_token_secret = conf['oauth_token_secret']
end

#Twitter.update('It can only be attributable to human error')


parentIds = Array.new
searchText = "#twss"

Twitter.search(searchText, :count => 50, :result_type => "recent").results.map do |status|
  tweet     = {}
    tweet['id']     = status.in_reply_to_status_id  
    tweet['userid'] = status.in_reply_to_user_id
    parentIds.push(tweet)
end

parentIds.each do |tweet|
  if !tweet['id'].nil? and !tweet['userid'].nil?
    user    = Twitter.user(tweet['userid'])
    if !user.protected
      status  = Twitter.status(tweet['id'])
      if /.*twss.*/i !~ status.text
        puts "\n#{status.from_user}: #{status.text}"
        puts "RT? y/n"
        answer = gets()
        if answer == "y\n"
          Twitter.retweet(tweet['id'])
          puts "RT'd!"
        else
          puts "Skipped"
        end
      end
    end
  end
end


