# Twitter API Ruby thin client wrapper library

[![Gem Version](https://badge.fury.io/rb/twitter_api.svg)](https://badge.fury.io/rb/twitter_api)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twitter_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twitter_api

## Usage

```ruby
require 'twitter_api'
require 'json'

# create a instance of API wrapper
t = TwitterAPI::Client.new({
  :consumer_key => 'YOUR_CONSUMER_KEY',
  :consumer_secret => 'YOUR_CONSUMER_SECRET',
  :token => 'YOUR_ACCESS_TOKEN',
  :token_secret => 'YOUR_ACCESS_SECRET'
})

# call GET statuses/user_timeline
res = t.get('https://api.twitter.com/1.1/statuses/user_timeline.json', {
  'screen_name' => 'niwasawa',
  'count' => '1'
})
puts res.headers
puts JSON.pretty_generate(JSON.parse(res.body))

# call GET statuses/user_timeline
res = t.statuses_user_timeline({
  'screen_name' => 'niwasawa',
  'count' => '1'
})
puts res.headers
puts JSON.pretty_generate(JSON.parse(res.body))

# call POST statuses/update
res = t.post('https://api.twitter.com/1.1/statuses/update.json', {
  'status' => "hello, world #{Time.now.to_i}"
})
puts res.headers
puts JSON.pretty_generate(JSON.parse(res.body))

# call POST statuses/update
res = t.statuses_update({
  'status' => "hello, world #{Time.now.to_i}"
})
puts res.headers
puts JSON.pretty_generate(JSON.parse(res.body))

# call GET statues/mention_timeline
res = t.statuses_mentions_timeline({
  'count' => '1'
})
puts res.headers
puts JSON.pretty_generate(JSON.parse(res.body))
```

## Documentation

Documentation for twitter_api
http://www.rubydoc.info/gems/twitter_api/

Reference Documentation — Twitter Developers
https://dev.twitter.com/rest/reference

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/niwasawa/twitter-api-ruby-thin-client-wrapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

