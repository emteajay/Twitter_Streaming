# Tweet Stream
### (Using Sferik's Twitter Gem 5.0.0)

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

gem 'twitter', github: 'sferik/twitter'
gem 'pry'
gem 'dotenv'
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


