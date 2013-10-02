# Tweet Stream
### (Using Sferik's Twitter Gem 5.0.0)
(All of this comes from the twitter gem's README.md, but I wanted to delve into a simple one-file application of the new
streaming feature).

This is going to be a quick to turorial on setting up the twitter gem (created by sferik) and using its new
streaming function to gather twitter data and perform some calculatios on them.

##Setup
To start, you'll need to install the gem:

```ruby
gem install twitter --version '5.0.0.rc.1'
```
If you have other versions of the gem, you can uninstall them by running 
```ruby
gem uninstall twitter
```
and selecting the versions you'd like to uninstall

Once you have the gem installed, go ahead and create a Gemfile and a main.rb (I've used twitter.rb). Your Gemfile
should looks something like: 
```ruby
# Gemfile
source 'https://rubygems.org' 

gem 'twitter', github: 'sferik/twitter' # the twitter gem
gem 'pry' # a really useful tool for inspecting elements in a console environment
gem 'dotenv' # for storing credentials
```
Go ahead and run bundle or bundle install
```ruby
bundle install
```

At the top of your main ruby file, require the following gems: 
```ruby
# main.rb
require 'twitter'
require 'dotenv'
require 'pry'
```

##Getting started
Now that the environment is set up, we can dive into using the gem. First, register your app with twitter [here](https://dev.twitter.com/apps/new).
You'll need to generate authentication tokens at the bottom of the app page. Keep this open, you'll need information
from it soon. For keeping authentication information secret, I'm going to be using [dotenv](https://github.com/bkeepers/dotenv). I 
highly recomend using it, and including your .env file in a .gitignore file, so that you don't upload all of your 
Twitter API credentials.

To start, use dotenv to store your credentials in a .env file, and at the top of your main.rb, load up the environment
variables with
```ruby
Dotenv.load
```

Now we're going to use these credentials to create a new Twitter::Streaming::Client object that will give us access to
a whole slew of streaming capabilities.
```ruby
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"] # where CONSUMER_KEY is defined in your .env file
  config.consumer_secret     = ENV["CONSUMER_SECRET"] # from .env
  config.access_token        = ENV["ACCESS_TOKEN"] # from .env
  config.access_token_secret = ENV["ACCESS_SECRET"] # from .env
end
```
```ruby
binding.pry # opens up a ruby console environment at this line
```
after this chunk of code, and try using pry to explore the client object a bit. If you hit errors when you run the file,
make sure that you have the correct version of the gem (see install command at top), and that your environment variables 
are being properly loaded.

## Using The Gem (A.K.A. GETTIN' DEM TWEETS)
Now that we have our client object, let's use it! We're going to filter the stream by a few keywords: 
```ruby
topics = ["barack","obama"]
```
Our streaming client has a method called 'filter' that will allow us to get at the stream while filtering by keywords. 
We can pass it our topics like so:

```ruby
client.filter(track: topics.join(",") do |tweet|
  puts tweet.text
end
```
This will filter the stream by our topics, and for each tweet, print the text (this is actually the example the gem's readme uses)
Let's filter this even further by specifying that we only want to print english texts.
```ruby
client.filter(track: topics.join(",")) do |tweet|
  puts tweet.text if tweet.lang == 'en' # this will stream only english tweets.
end
```
Now, why don't we end our stream when we have about 100 tweets, and let's stor the tweet information at the same time. We 
can also output a counter to see the tweets we're getting.
```ruby
stored_tweets = []
tweets_stored = 0

client.filter(track: topics.join(",")) do |tweet|
  if tweet.lang == 'en'
    stored_tweets << {username: tweet.attrs[:user][:screenname], tweet_text: tweet.text}
    tweets_stored += 1
    puts "#{tweets_stored} tweets gathered"
  end
  break if tweets_stored >= 100
end

binding.pry
```
So this will store each of our tweets as an object with both the username of the tweeter and the text that they tweeted. 
It will also output the number of tweets we have gathered. I added a binding.pry at the end, otherwise the file will just end
and we won't be able to see all of our beautiful tweets!

## Doing Stuff With les Tweets
From here on I'm going to assume that we're in a context where I ahve a collection of stored_tweets, each of which is
a hash object containing the keys :username and :tweet_text. So how about we break all of the text down into one single
array of all the words from all of the tweets we've pulled. We can do this using a simple ruby map:

```ruby
# assuming we have stored_tweets array

all_words = stored_tweets.map do |tweet_datum|
  tweet_datum[:tweet_text].split(' ')
end

all_words.flatten!
```
Because the map function will return an array off arrays, with each subarray being an array of all the words from a single
tweet's text, we're going to flatten the result to get a single array containing all the words we've captured.
  
