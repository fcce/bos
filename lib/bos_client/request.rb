# encoding: UTF-8
module BosClient
  class Request
    include BosClient::Helper
    attr_accessor :uri, :options

    def initialize(url, options = {})
      @uri = URI(URI.encode(url))
      @options = options
    end

    def run
      request = format_request
      resolve_response request.run
    end

    def response_headers
      request = format_request
      resolve_response_headers request.run
    end

    private

    def format_request
      headers = { 'host' => @uri.host }

      if @options[:headers].nil?
        @options[:headers] = headers
      else
        @options[:headers].merge! headers
      end

      @options[:params] = {} if @options[:params].nil?

      request = Typhoeus::Request.new @uri.to_s, @options
      BosClient::Authable.authorize_request request
    end

    def resolve_response(response)
      if response.success?
        ret = resolve_bos_resault response
        snake_hash_keys(ret)
      elsif response.timed_out?
        raise BosClient::Error::TimeOut, 'got a time out'
      elsif response.code == 0
        raise BosClient::Error::HttpError, response.return_message
      else
        ret = resolve_bos_resault response
        if ret[:data][:code]
          raise BosClient::Error.bos_error ret[:data][:code], ret[:data][:message]
        else
          raise BosClient::Error::HttpError, "HTTP request failed: #{response.code}"
        end
      end
    end

    def resolve_bos_resault(r)
      ret = if !r.body.empty?
              JSON.parse r.body, symbolize_names: true
            else
              {}
            end

      {
        result: true,
        status: r.code,
        ts: Time.now.to_i,
        version: 1.0,
        data: ret
      }
    rescue StandardError => e
      raise BosClient::Error::JSONError, e.message
    end

    def resolve_response_headers(r)
      ret = JSON.parse r.headers, symbolize_names: true
      {
        result: true,
        status: r.code,
        ts: Time.now.to_i,
        version: 1.0,
        data: ret
      }
    rescue StandardError => e
      raise BosClient::Error::JSONError, e.message
    end
  end
end
