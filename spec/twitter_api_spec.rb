require 'spec_helper'
require 'open-uri'
require 'stringio'

describe TwitterAPI do
  it 'has a version number' do
    expect(TwitterAPI::VERSION).not_to be nil
  end
end

# for mock
class Dummy
  def self.JSON
    # a dummy of JSON response
    io = StringIO.new('[{}]')
    OpenURI::Meta.init(io)
  end
end

# mock
module Kernel
  def open(name, *rest, &block)
    Dummy.JSON
  end
end

# mock
module Net
  class HTTP
    def request_post(path, data, header = nil)
      Dummy.JSON
    end
    def request(request, data = nil)
      Dummy.JSON
    end
  end
end

describe TwitterAPI::Client do

  credential = {
    :consumer_key => 'YOUR_CONSUMER_KEY',
    :consumer_secret => 'YOUR_CONSUMER_SECRET',
    :token => 'YOUR_ACCESS_TOKEN',
    :token_secret => 'YOUR_ACCESS_SECRET'
  }
  t = TwitterAPI::Client.new(credential)

  it 'has a method get' do
    resource_url = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
    params = {
      'screen_name' => 'YOUR_SCREEN_NAME',
      'count' => '1'
    }
    expect(t.get(resource_url, params)).not_to be nil
  end

  it 'has a method post' do
    resource_url = 'https://api.twitter.com/1.1/statuses/update.json'
    params = {
      'status' => 'The text of your status update, typically up to 140 characters.'
    }
    expect(t.post(resource_url, params)).not_to be nil
  end

  it 'has a method post_multipart' do
    resource_url = 'https://upload.twitter.com/1.1/media/upload.json'
    params = {
      'media' => '0000000000000000'
    }
    expect(t.post_multipart(resource_url, params)).not_to be nil
  end

  it 'has a method direct_messages' do
    params = {
      'count' => '200'
    }
    expect(t.direct_messages(params)).not_to be nil
  end

  it 'has a method direct_messages_sent' do
    params = {
      'count' => '200'
    }
    expect(t.direct_messages_sent(params)).not_to be nil
  end

  it 'has a method favorites_list' do
    params = {
      'user_id' => '0000000000000000'
    }
    expect(t.favorites_list(params)).not_to be nil
  end

  it 'has a method geo_id_place_id' do
    params = {
      'place_id' => '0000000000000000'
    }
    expect(t.geo_id_place_id(params)).not_to be nil
  end

  it 'has a method search_tweets' do
    params = {
      'q' => 'search query',
      'count' => '1'
    }
    expect(t.search_tweets(params)).not_to be nil
  end

  it 'has a method statuses_mentions_timeline' do
    params = {
      'count' => '1'
    }
    expect(t.statuses_mentions_timeline(params)).not_to be nil
  end

  it 'has a method statuses_show_id' do
    params = {
      'id' => '00000000',
    }
    expect(t.statuses_show_id(params)).not_to be nil
  end

  it 'has a method statuses_user_timeline' do
    params = {
      'screen_name' => 'YOUR_SCREEN_NAME',
      'count' => '1'
    }
    expect(t.statuses_user_timeline(params)).not_to be nil
  end

  it 'has a method users_lookup' do
    params = {
      'screen_name' => 'YOUR_SCREEN_NAME'
    }
    expect(t.users_lookup(params)).not_to be nil
  end

  it 'has a method media_upload' do
    params = {
      'media' => 'IMAGE_RAW_BINARY'
    }
    expect(t.media_upload(params)).not_to be nil
  end

  it 'has a method statuses_update' do
    params = {
      'status' => 'The text of your status update, typically up to 140 characters.'
    }
    expect(t.statuses_update(params)).not_to be nil
  end
 
end

