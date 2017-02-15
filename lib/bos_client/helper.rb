# encoding: UTF-8
module BosClient
  module Helper

   def snake_hash_keys value
      case value
      when Array
        value.map { |v| snake_hash_keys(v) }
      when Hash
        snake_hash(value)
      else
        value
      end
    end

    def snake_hash(value)
      Hash[value.map { |k, v| [underscore_key(k), snake_hash_keys(v)] }]
    end

    def underscore_key(k)
      if k.is_a? Symbol
        underscore(k.to_s).to_sym
      elsif k.is_a? String
        underscore(k)
      else
        k
      end
    end

    def underscore(string)
      string.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end
  end
end
