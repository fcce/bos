# encoding: UTF-8
module BosClient
  DEFAULTS = {
    scheme: 'http',
    url: 'bcebos.com',
    location: 'bj',
    expiration_in_seconds: 1800,
    access_key_id: '*****',
    secret_access_key: '*****'
  }.freeze

  class << self
    def options
      @options ||= DEFAULTS.dup
    end

    attr_writer :options

    def configure
      yield self
    end

    def host
      "#{options[:scheme]}://#{options[:location]}.#{options[:url]}"
    end
  end

  DEFAULTS.each do |k, _v|
    define_singleton_method "#{k}=" do |value|
      options.merge!(k => value)
    end

    define_singleton_method k do
      options[k]
    end
  end
end
