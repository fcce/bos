require 'spec_helper'

describe BosClient do
  it 'has a version number' do
    expect(BosClient::VERSION).not_to be nil
  end

  it 'config can set host' do
    BosClient.configure do |config|
      config.scheme = 'http'
      config.url = 'bcebos.com'
      config.location = 'bj'
    end
    expect(BosClient.host).to eq('http://bj.bcebos.com')
  end

  it 'config can set expiration_in_seconds' do
    BosClient.configure do |config|
      config.expiration_in_seconds = 1800
    end
    expect(BosClient.expiration_in_seconds).to eq(1800)
  end

  it 'config can set access_key_id' do
    BosClient.configure do |config|
      config.access_key_id = '1234'
    end
    expect(BosClient.access_key_id).to eq('1234')
  end

  it 'config can set secret_access_key' do
    BosClient.configure do |config|
      config.secret_access_key = '12345'
    end
    expect(BosClient.secret_access_key).to eq('12345')
  end

  it 'can list buckets' do
    config_bos_client
    expect(BosClient.buckets).to be_a(Array)
  end
end
