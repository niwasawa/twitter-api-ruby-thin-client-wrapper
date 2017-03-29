require 'twitter_api/version'

require 'net/https'
require 'open-uri'
require 'simple_oauth'
require 'tempfile'

# Twitter API Ruby thin client wrapper library
# {https://github.com/niwasawa/twitter-api-ruby-thin-client-wrapper}
module TwitterAPI

  # A base client class.
  class BaseClient

    # Initializes a BaseClient object.
    #
    # @param credentials [Hash] Credentials
    # @return [TwitterAPI::BaseClient]
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

    # Calls a Twitter REST API using POST (multipart/form-data) method.
    #
    # @param resource_url [String] Resource URL
    # @param params [Hash] Parameters
    # @param data [Array] Posts Multipart data
    # @return [TwitterAPI::Response]
    def post_multipart(resource_url, params, data={})
      headers = {'Authorization' => authorization('POST', resource_url, params)}
      url = resource_url + '?' + URI.encode_www_form(params)
      uri = URI.parse(url)
      form_data = []
      data.each{|k,v|
        form_data << [k,v]
      }
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri.request_uri, headers)
      req.set_form(form_data, 'multipart/form-data')
      res = http.start{|h|
        h.request(req)
      }
      Response.new(res)
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

  # A client class.
  class Client < BaseClient

    # Initializes a Client object.
    #
    # @param credentials [Hash] Credentials
    # @return [TwitterAPI::Client]
    def initialize(credentials)
      super
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

    # Calls a Twitter REST API using POST (multipart/form-data) method.
    #
    # @param resource_url [String] Resource URL
    # @param params [Hash] Parameters
    # @param data [Array] Posts Multipart data
    # @return [TwitterAPI::Response]
    def post_multipart(resource_url, params, data={})
      headers = {'Authorization' => authorization('POST', resource_url, params)}
      url = resource_url + '?' + URI.encode_www_form(params)
      uri = URI.parse(url)
      form_data = []
      data.each{|k,v|
        form_data << [k,v]
      }
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri.request_uri, headers)
      req.set_form(form_data, 'multipart/form-data')
      res = http.start{|h|
        h.request(req)
      }
      Response.new(res)
    end

    # GET geo/id/:place_id
    # {https://dev.twitter.com/rest/reference/get/geo/id/place_id}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def geo_id_place_id(params)
      resource_url = "https://api.twitter.com/1.1/geo/id/#{params['place_id']}.json"
      get(resource_url, params)
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

    # GET statuses/show/:id
    # {https://dev.twitter.com/rest/reference/get/statuses/show/id}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def statuses_show_id(params)
      resource_url = 'https://api.twitter.com/1.1/statuses/show.json'
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

    # GET users/lookup
    # {https://dev.twitter.com/rest/reference/get/users/lookup}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def users_lookup(params)
      resource_url = 'https://api.twitter.com/1.1/users/lookup.json'
      get(resource_url, params)
    end

    # POST media/upload
    # {https://dev.twitter.com/rest/reference/post/media/upload}
    #
    # @param params [Hash] Parameters
    # @return [TwitterAPI::Response]
    def media_upload(params)
      resource_url = 'https://upload.twitter.com/1.1/media/upload.json'
      post_multipart(resource_url, {}, params)
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
      @headers = make_headers
      @body = make_body
    end

    # Returns HTTP headers.
    #
    # @return [Net::HTTPHeader]
    # @return [Hash]
    def headers
      @headers
    end

    # Returns HTTP body.
    #
    # @return [String]
    def body
      @body
    end

    private

    # Returns HTTP headers.
    #
    # @return [Net::HTTPHeader]
    # @return [Hash]
    def make_headers
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
    def make_body
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

