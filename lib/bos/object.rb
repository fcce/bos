# encoding: UTF-8
module Bos
  class Object
    attr_accessor :bucket, :size, :path, :last_modified, :name, :storage_class

    def initialize(options = {})
      @bucket = options[:bucket]
      @size = options[:size]
      @file = options[:key]
      @path, @name =  File.split(options[:key])
      @last_modified = options[:last_modified]
      @storage_class = options[:storage_class]
    end


    def save
      save_to nil
    end

    def save_as name
      save_to nil, name
    end

    def save_to path, name = nil
      headers = {
                 "host" => @bucket.bucket_host,
                 }

      params = {}
      url = URI.encode("http://#{@bucket.bucket_host}/#{@file}")
      request = Typhoeus::Request.new(url, method: :get,headers:headers,params:params)
      request = Bos::Authable.authorize_request(request)

      request.on_complete do |response|
        if path
          flie = "#{path}/#{name || @name}"
        else
          flie = "#{name || @name}"
        end
        write_file flie, response.body
      end
      request.run
    end

    def destory
      request = Bos::Request.new "#{@bucket.bucket_host}/#{@file}", method: :delete
      response = request.run
      response[:result]
    end

    def self.upload options = {}
      bucket = options[:bucket]
      file = options[:file]
      origin_file_name = File.basename(file)
      filename = options[:filename] || origin_file_name
      path = options[:path] || ''
      storage_class = options[:storage_class] || "STANDARD"
      headers = options[:headers] || {}

      params = {
        append: ""
      }
      headers.merge!({"x-bce-storage-class" => storage_class})
      request = Bos::Request.new "#{bucket.bucket_host}/#{File.join(path,filename)}?append", method: :post, params:params, headers: headers, body: File.open(file,"r").read
      response = request.run
      response[:result]
    end

    private
    def write_file(filename, data)
      file = File.new(filename, "wb")
      file.write(data)
      file.close
    end

  end
end
