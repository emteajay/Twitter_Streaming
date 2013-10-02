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

client = Twitter::Streaming::Client.new do |config|
	config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

topic = "obama"
obama_tweets = []
i = 0

client.filter(track: topic) do |tweet|
	if tweet.lang == 'en'
		 i += 1
		 obama_tweets << {username: tweet.attrs[:user][:screen_name], tweet: tweet.text}
		 puts "#{i} tweets gathered"
	end
	break if i >= 100
end

words = obama_tweets.map do |tweet_datum|
	tweet_datum[:tweet].split(' ')
end

words.flatten!

frequencies = {}

words.each do |word|
	frequencies[word.to_sym] ||= 0
	# same as
	# if frequencies[word.to_sym] == nil
	# 	frequencies[word.to_sym] = 0
	frequencies[word.to_sym] += 1
end

binding.pry
