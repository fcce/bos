$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bos_client'
# Typhoeus::Config.verbose = true
require "simplecov"
SimpleCov.start

require 'knapsack'

# CUSTOM_CONFIG_GOES_HERE

Knapsack::Adapters::RSpecAdapter.bind

def config_bos_client
  BosClient.configure do |config|
    config.scheme = 'http'
    config.url = 'bcebos.com'
    config.location = 'bj'
    config.expiration_in_seconds = 1800
    config.access_key_id = ENV['BOS_AK']
    config.secret_access_key = ENV['BOS_SK']
  end
end
