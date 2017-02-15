# encoding: UTF-8
module BosClient
  class Error < StandardError
    class << self

      def bos_error name, message
        unless const_defined?(name)
          BosClient::Error.const_set(name.to_sym, Class.new(BosClient::Error)).new(message)
        else
          eval "BosClient::Error::#{name}.new \"#{message}\""
        end
      end

      def const_missing(name)
        BosClient::Error.const_set(name.to_sym,Class.new(BosClient::Error))
      end
    end
  end
end
