require 'twitter_api/version'

require 'net/https'
require 'open-uri'
require 'simple_oauth'

# Twitter API Ruby thin client wrapper library
module TwitterAPI

  class Client

    def initialize(credentials)
      @credentials = credentials
    end

    def authorization(method, url, params)
      SimpleOAuth::Header.new(method, url, params, @credentials).to_s
    end

    # @return StringIO or Tempfile
    def get(base_url, params)
      headers = {'Authorization' => authorization('GET', base_url, params)}
      url = base_url + '?' + URI.encode_www_form(params)
      res = open(url, headers)
      Response.new(res)
    end

    # @return Net::HTTPResponse
    def post(base_url, params, data=nil)
      headers = {'Authorization' => authorization('POST', base_url, params)}
      url = base_url + '?' + URI.encode_www_form(params)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.request_post(url, data, headers)
      Response.new(res)
    end

    # GET search/tweets — Twitter Developers
    # https://dev.twitter.com/rest/reference/get/search/tweets
    def search_tweets(params)
      base_url = 'https://api.twitter.com/1.1/search/tweets.json'
      get(base_url, params)
    end

    # GET statuses/mentions_timeline — Twitter Developers
    # https://dev.twitter.com/rest/reference/get/statuses/mentions_timeline
    def statuses_mentions_timeline(params)
      base_url = 'https://api.twitter.com/1.1/statuses/mentions_timeline.json'
      get(base_url, params)
    end

    # GET statuses/user_timeline — Twitter Developers
    # https://dev.twitter.com/rest/reference/get/statuses/user_timeline
    def statuses_user_timeline(params)
      base_url = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
      get(base_url, params)
    end

    # POST statuses/update — Twitter Developers
    # https://dev.twitter.com/rest/reference/post/statuses/update
    def statuses_update(params)
      base_url = 'https://api.twitter.com/1.1/statuses/update.json'
      post(base_url, params)
    end
  end

  class Response

    def initialize(res)
      @res = res
    end

    # @return Net::HTTPHeader or Hash
    def headers
      if @res.kind_of?(Net::HTTPResponse)
        @res
      elsif @res.kind_of?(StringIO)
        @res.meta
      elsif @res.kind_of?(Tempfile)
        @res.meta
      else
        nil
      end
    end

    # @return String
    def body
      if @res.kind_of?(Net::HTTPResponse)
        @res.body
      elsif @res.kind_of?(StringIO)
        @res.read
      elsif @res.kind_of?(Tempfile)
        @res.read
      else
        nil
      end
    end
  end

end

