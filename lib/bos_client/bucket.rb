# encoding: UTF-8
module BosClient
  class Bucket
    attr_accessor :name, :bucket_host, :creation_date, :bucket_host

    def initialize(options = {})
      @name = options[:name]
      @location = options[:location] || BosClient.location
      @creation_date = options[:creation_date]
      @bucket_host = "#{BosClient.scheme}://#{@name}.#{@location}.#{BosClient.url}"
    end

    def accessable?
      request = BosClient::Request.new @bucket_host, method: :head
      response = request.run
      response[:result]
    end

    def save
      request = BosClient::Request.new @bucket_host, method: :put
      response = request.run
      response[:result]
    end

    def destory
      request = BosClient::Request.new @bucket_host, method: :delete
      response = request.run
      response[:result]
    end

    ## objects
    def objects(options = {})
      response = list_objects options.merge(delimiter: '/')
      objs = response[:data][:contents]
      objs.map { |obj| BosClient::Object.new ({bucket: self}.merge(obj)) }
    end

    def dirs(options = {})
      response = list_objects options
      data = response[:data][:contents]
      data = data.find_all { |e| is_dir?(e[:key]) }
      data.map { |e| e[:key] }
    end

    def dir_objects(prefix, options = {})
      response = list_objects options.merge(delimiter: '/', prefix: prefix)
      data = response[:data][:contents]
      objs = data.find_all { |e| !is_dir?(e[:key]) }
      objs.map { |obj| BosClient::Object.new ({bucket: self}.merge(obj)) }
    end

    private

    def is_dir?(name)
      name.end_with?('/')
    end

    def list_objects(options = {})
      prefix = options.fetch(:prefix, nil)
      max_keys = options.fetch(:max_keys, 1000)
      marker = options.fetch(:marker, nil)
      delimiter = options.fetch(:delimiter, nil)
      params = { maxKeys: max_keys }
      params[:prefix] = prefix unless prefix.nil?
      params[:marker] = marker unless marker.nil?
      params[:delimiter] = delimiter unless delimiter.nil?
      request = BosClient::Request.new @bucket_host, method: :get, params: params
      request.run
    end
  end
end
