require 'spec_helper'

describe Bos do
  it 'has a version number' do
    expect(Bos::VERSION).not_to be nil
  end

  it 'config can set host' do
    Bos.configure do |config|
      config.scheme= 'http'
      config.url= 'bcebos.com'
      config.location= 'bj'
    end
    expect(Bos.host).to eq('http://bj.bcebos.com')
  end

  it 'config can set expiration_in_seconds' do
    Bos.configure do |config|
      config.expiration_in_seconds= 1800
    end
    expect(Bos.expiration_in_seconds).to eq(1800)
  end

  it 'config can set access_key_id' do
    Bos.configure do |config|
      config.access_key_id= '1234'
    end
    expect(Bos.access_key_id).to eq('1234')
  end

  it 'config can set secret_access_key' do
    Bos.configure do |config|
      config.secret_access_key= '12345'
    end
    expect(Bos.secret_access_key).to eq('12345')
  end

  it 'can list buckets' do
    config_bos
    expect(Bos.buckets).to be_a(Array)
  end


end
