# @tcclevela
# using the twitter gem to stream
require 'twitter'
require 'dotenv'
require 'pry'

Dotenv.load

# if we want to get static twitter information:

# client = Twitter::REST::Client.new do |config|
#   config.consumer_key        = ENV["CONSUMER_KEY"]
#   config.consumer_secret    = ENV["CONSUMER_SECRET"]
#   config.access_token        = ENV["ACCESS_TOKEN"]
#   config.access_token_secret = ENV["ACCESS_SECRET"]
# end

# uses the credentials stored in .env to authenticate
# and get our streaming client object
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

# sets the topics we want to search, initialize the empty array and counter
topic = ['barack', 'obama']
stored_tweets = []
tweets_stored = 0

# uses the Twitter::Streaming::Client filter fuction to track out topic parameters
# and store the username and text of each tweet that it matches against them. 
client.filter(track: topic) do |tweet|
  if tweet.lang == 'en'
    tweets_stored += 1
    stored_tweets << {username: tweet.attrs[:user][:screen_name], 
                      tweet:    tweet.text}
    puts "#{tweets_stored} tweets gathered"
  end
  break if tweets_stored >= 100 # stops the stream after 100 tweets
end

# maps the stored tweets to an array containing arrays of the
# words from each tweet's text)
words = stored_tweets.map do |tweet_datum|
  tweet_datum[:tweet].split(' ')
end

# compresses the 2D words array to a one dimensional list of all the words
words.flatten!

frequencies = {} # could also say frequencies = Hash.new(0) and
                 # not use the ||= operator below (but I think the ||=
                 # is neat little operator)

# loops through all of the words and calculates the frequency of each word
# over the dataset 
words.each do |word|
	frequencies[word.to_sym] ||= 0
	frequencies[word.to_sym] += 1
end

# check out the results in pry or write more code to play with the data!
binding.pry
