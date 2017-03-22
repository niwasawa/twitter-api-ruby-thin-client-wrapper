require "spec_helper"
require "stringio"

describe TwitterAPI do
  it "has a version number" do
    expect(TwitterAPI::VERSION).not_to be nil
  end
end

# mock
module Kernel
  def open(name, *rest, &block)
    # a dummy of JSON response
    io = StringIO.new('[{}]')
    OpenURI::Meta.init(io)
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

  it 'has a method statuses_user_timeline' do
    params = {
      'screen_name' => 'YOUR_SCREEN_NAME',
      'count' => '1'
    }
    expect(t.statuses_user_timeline(params)).not_to be nil
  end

end

