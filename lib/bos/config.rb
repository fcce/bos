# encoding: UTF-8
module Bos

   DEFAULTS = {
      scheme: 'http',
      url: 'bcebos.com',
      location: 'bj',
      expiration_in_seconds: 1800,
      access_key_id: '*****',
      secret_access_key: '*****'
    }

  class << self
    def options
      @options ||= DEFAULTS.dup
    end

    def options=(opts)
      @options = opts
    end

    def configure
      yield self
    end

    def host
      "#{options[:scheme]}://#{options[:location]}.#{options[:url]}"
    end

  end

  DEFAULTS.each do |k, v|
    self.define_singleton_method "#{k}=" do |value|
      self.options.merge!(k => value)
    end

    self.define_singleton_method k do
      self.options[k]
    end
  end

end
