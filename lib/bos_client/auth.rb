# encoding: UTF-8
require 'openssl'
require 'typhoeus'
require 'uri'
module BosClient
  class Authable

    def self.authorize_request request
      default_headers = get_default_headers request
      request.options[:headers].merge! default_headers
      authorization = sign(request)
      request.options[:headers].merge!({"Authorization" => authorization})
      request
    end

    private
    class << self
      def get_canonical_time t = Time.now.to_i
        Time.at(t).utc.strftime("%FT%TZ")
      end

      def get_default_headers request
        {
          "content-type" =>"text/plain",
          "x-bce-date" => get_canonical_time,
          "content-length" => (request.options[:body] || "").length
        }
          # todo PUT 方法计算的签名错误，content-length 的问题，暂时处理。
        # headers.merge!({"content-length" => 0}) if request.options[:method] == :put
      end

      def get_canonical_uri request
        uri  = URI(request.base_url)
        url_path = URI.encode(uri.path)
        url_path == '' ? '/' : url_path
      end

      def get_canonical_query_string request
        params = request.options[:params]
        params = params.map do |k, v|
          "#{URI.encode(k.to_s)}=#{encode_slash(URI.encode(v.to_s))}"
        end.compact.sort.join('&')
        params
      end

      def get_canonical_headers request
        headers_to_sign_keys = ["host", "content-md5", "content-length", "content-type"]
        headers_to_sign = []
        canonical_headers_downcase = request.options[:headers].each do |k, v|
          if headers_to_sign_keys.include?(k) || k.start_with?('x-bce')
            headers_to_sign << "#{encode(k.to_s.downcase)}:#{encode(v.to_s)}"
          end
        end
        headers_to_sign.compact.sort.join("\n")
      end

      def get_http_method request
        (request.options[:method] || 'get').upcase
      end

      def encode string
        URI.encode(string, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end

      def encode_slash str
        str.gsub(/\//,'%2F')
      end

      def sign request
        digest = OpenSSL::Digest.new('sha256')
        sign_key_prefix = "bce-auth-v1/#{BosClient.access_key_id}/#{get_canonical_time()}/#{BosClient.expiration_in_seconds}"
        sign_key = OpenSSL::HMAC.hexdigest digest, BosClient.secret_access_key, sign_key_prefix

        http_method = get_http_method request

        canonical_uri = get_canonical_uri request
        canonical_query_string = get_canonical_query_string request
        canonical_headers = get_canonical_headers request
        string_to_sign = [http_method, canonical_uri, canonical_query_string, canonical_headers].join("\n")
        sign_result = OpenSSL::HMAC.hexdigest digest, sign_key, string_to_sign
        "#{sign_key_prefix}//#{sign_result}"
      end
    end
  end
end
