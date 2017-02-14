# encoding: UTF-8
module Bos
  class Error < StandardError
    class << self

      def bos_error name, message
        unless const_defined?(name)
          Bos::Error.const_set(name.to_sym, Class.new(Bos::Error)).new(message)
        else
          eval "Bos::Error::#{name}.new \"#{message}\""
        end
      end

      def const_missing(name)
        Bos::Error.const_set(name.to_sym,Class.new(Bos::Error))
      end
    end
  end
end
