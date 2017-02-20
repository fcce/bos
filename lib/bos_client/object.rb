# encoding: UTF-8
module BosClient
  class Object
    attr_accessor :bucket, :size, :path, :last_modified, :name, :storage_class

    def initialize(options = {})
      @bucket = options[:bucket]
      @size = options[:size]
      @file = options[:key]
      @path, @name = File.split(options[:key])
      @last_modified = options[:last_modified]
      @storage_class = options[:storage_class]
    end

    def save
      save_to nil
    end

    def save_as(name)
      save_to nil, name
    end

    def save_to(path, name = nil)
      headers = {
        'host' => @bucket.bucket_host
      }

      params = {}
      url = URI.encode("http://#{@bucket.bucket_host}/#{@file}")
      request = Typhoeus::Request.new url,
                                      method: :get,
                                      headers: headers,
                                      params: params
      request = BosClient::Authable.authorize_request(request)

      request.on_complete do |response|
        flie = if path
                 "#{path}/#{name || @name}"
               else
                 (name || @name).to_s
               end
        write_file flie, response.body
      end
      request.run
    end

    def destory
      request = BosClient::Request.new  "#{@bucket.bucket_host}/#{@file}",
                                        method: :delete
      response = request.run
      response[:result]
    end

    def self.upload(options = {})
      bucket = options[:bucket]
      file = options[:file]
      origin_file_name = File.basename(file)
      filename = options[:filename] || origin_file_name
      path = options[:path] || ''
      storage_class = options[:storage_class] || 'STANDARD'
      headers = options[:headers] || {}

      params = {
        append: ''
      }
      headers['x-bce-storage-class'] = storage_class

      url = "#{bucket.bucket_host}/#{File.join(path, filename)}?append"
      request = BosClient::Request.new  url,
                                        method: :post,
                                        params: params,
                                        headers: headers,
                                        body: File.open(file, 'r').read
      response = request.run
      response[:result]
    end

    def self.fetch(options = {})
      bucket = options[:bucket]
      filename = options[:filename]
      path = options[:path] || ''
      storage_class = options[:storage_class] || 'STANDARD'
      fetch_mode = options[:fetch_mode] || 'sync'
      fetch_source = options[:fetch_source]
      headers = options[:headers] || {}

      params = {
        fetch: ''
      }

      headers['x-bce-storage-class'] = storage_class
      headers['x-bce-fetch-mode'] = fetch_mode
      headers['x-bce-fetch-source'] = fetch_source
      url = "#{bucket.bucket_host}/#{File.join(path, filename)}?fetch"
      request = BosClient::Request.new  url,
                                        method: :post,
                                        params: params,
                                        headers: headers
      response = request.run
      response[:result]
    end

    private

    def write_file(filename, data)
      file = File.new(filename, 'wb')
      file.write(data)
      file.close
    end
  end
end
