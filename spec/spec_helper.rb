$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bos'

def config_bos
  Bos.configure do |config|
    config.scheme= 'http'
    config.url= 'bcebos.com'
    config.location= 'bj'
    config.expiration_in_seconds= 1800
    config.access_key_id= ENV["BOS_AK"]
    config.secret_access_key= ENV["BOS_SK"]
  end
end
