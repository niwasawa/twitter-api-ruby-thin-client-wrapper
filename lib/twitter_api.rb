require 'twitter_api/version'

require 'net/https'
require 'open-uri'
require 'simple_oauth'

# Twitter API Ruby thin client wrapper library
# {https://github.com/niwasawa/twitter-api-ruby-thin-client-wrapper}
module TwitterAPI

  # A client class.
  class Client

    # Initializes a Client object.
    #
    # @param credentials [Hash] Credentials
    # @return [TwitterAPI::Client]
    def initialize(credentials)
      @credentials = credentials
    end

    # Calls a Twitter REST API using GET method.
    #
    # @param resource_url [String] Resource URL
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def get(resource_url, params)
      headers = {'Authorization' => authorization('GET', resource_url, params)}
      url = resource_url + '?' + URI.encode_www_form(params)
      res = open(url, headers)
      Response.new(res)
    end

    # Calls a Twitter REST API using POST method.
    #
    # @param resource_url [String] Resource URL
    # @param params [Hash] Parameters
    # @param data [String] Posts data
    # @return [TwitterAPI::Response]
    def post(resource_url, params, data=nil)
      headers = {'Authorization' => authorization('POST', resource_url, params)}
      url = resource_url + '?' + URI.encode_www_form(params)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.request_post(url, data, headers)
      Response.new(res)
    end

    # GET search/tweets
    # {https://dev.twitter.com/rest/reference/get/search/tweets}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def search_tweets(params)
      resource_url = 'https://api.twitter.com/1.1/search/tweets.json'
      get(resource_url, params)
    end

    # GET statuses/mentions_timeline
    # {https://dev.twitter.com/rest/reference/get/statuses/mentions_timeline}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def statuses_mentions_timeline(params)
      resource_url = 'https://api.twitter.com/1.1/statuses/mentions_timeline.json'
      get(resource_url, params)
    end

    # GET statuses/user_timeline
    # {https://dev.twitter.com/rest/reference/get/statuses/user_timeline}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def statuses_user_timeline(params)
      resource_url = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
      get(resource_url, params)
    end

    # POST statuses/update
    # {https://dev.twitter.com/rest/reference/post/statuses/update}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def statuses_update(params)
      resource_url = 'https://api.twitter.com/1.1/statuses/update.json'
      post(resource_url, params)
    end

    private

    # Returns string of authorization.
    #
    # @param method [String] A HTTP method
    # @param url [String] A URL
    # @param params [Hash] Parameters
    # @return [String]
    def authorization(method, url, params)
      SimpleOAuth::Header.new(method, url, params, @credentials).to_s
    end

  end

  # A HTTP Response class.
  class Response

    # Initializes a Response object.
    #
    # @param res [StringIO]
    # @param res [Tempfile]
    # @return [TwitterAPI::Client]
    def initialize(res)
      @res = res
    end

    # Returns HTTP headers.
    #
    # @return [Net::HTTPHeader]
    # @return [Hash]
    def headers
      if @res.kind_of?(Net::HTTPResponse)
        @res # Net::HTTPHeader
      elsif @res.kind_of?(StringIO)
        @res.meta # Hash
      elsif @res.kind_of?(Tempfile)
        @res.meta # Hash
      else
        nil
      end
    end

    # Returns HTTP body.
    #
    # @return [String]
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

