# encoding: UTF-8
module Bos
  class Request
    include Bos::Helper
    attr_accessor :uri, :options

    def initialize url , options={}
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
      headers = { "host" => @uri.host }

      if @options[:headers].nil?
        @options[:headers] = headers
      else
        @options[:headers].merge! headers
      end

      if @options[:params].nil?
        @options[:params] = {}
      end

      request = Typhoeus::Request.new @uri.to_s, @options
      Bos::Authable.authorize_request request
    end

    def resolve_response response
      if response.success?
        ret = resolve_bos_resault response
        return snake_hash_keys(ret)
      elsif response.timed_out?
        raise Bos::Error::TimeOut.new "got a time out"
      elsif response.code == 0
        raise Bos::Error::HttpError.new response.return_message
      else
        ret = resolve_bos_resault response
        if ret[:data][:code]
          raise  Bos::Error.bos_error ret[:data][:code], ret[:data][:message]
        else
          raise Bos::Error::HttpError.new "HTTP request failed: #{response.code.to_s}"
        end
      end
    end

    def resolve_bos_resault r
      begin
        if r.body.size > 0
          ret = JSON.parse r.body,{:symbolize_names => true}
        else
          ret = {}
        end

        result = {
          result: true,
          status: r.code,
          ts: Time.now.to_i,
          version: 1.0,
          data: ret
        }
      rescue Exception => e
        raise Bos::Error::JSONError.new e.message
      end
    end

    def resolve_response_headers r
      begin
        ret = JSON.parse r.headers,{:symbolize_names => true}
        result = {
          result: true,
          status: r.code,
          ts: Time.now.to_i,
          version: 1.0,
          data: ret
        }
      rescue Exception => e
        raise Bos::Error::JSONError.new e.message
      end
    end
  end
end
