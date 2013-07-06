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

# Load in config file
settings = YAML.load_file("config.yml")
conf = settings['config']

# Create twitter object with proper authentication
Twitter.configure do |config|
  config.consumer_key       = conf['consumer_key']
  config.consumer_secret    = conf['consumer_secret']
  config.oauth_token        = conf['oauth_token']
  config.oauth_token_secret = conf['oauth_token_secret']
end

# Store all out potential RT's here
tweets = Array.new

# Search temrs to use to select tweets
searchText = "#twss"
searchText = "that's what she said"

# Query twitter for tweets, but save the parent tweet's info
Twitter.search(searchText, :count => 50, :result_type => "recent").results.map do |status|
  tweet     = {}
    tweet['id']     = status.in_reply_to_status_id  
    tweet['userid'] = status.in_reply_to_user_id
    tweets.push(tweet)
end

# Loop through the tweets and select the best ones
tweets.each do |tweet|
  
  # Only look at tweets that were replies
  if !tweet['id'].nil? and !tweet['userid'].nil?
    
    # Grab the user object for the user who wrote the tweet  
    user    = Twitter.user(tweet['userid'])

    # Skip if the parent user was protected
    if !user.protected

      # Now grab the actual tweet we might want to RT
      status  = Twitter.status(tweet['id'])
  
      # Make sure it doesn't say twss in the tweet itself (kind of ruins the joke)
      if /.*twss.*/i !~ status.text

        # Prompt the user with the tweet and ask him whether to RT it or now
        puts "\n#{status.from_user}: #{status.text}"
        puts "RT? y/n"
        answer = gets()

        # Take action based on the input
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


