require 'spec_helper'

describe BosClient::Request do
  before do
    config_bos_client
  end

  it 'run method raise an error' do
    request = BosClient::Request.new 'https://ruby-china.org/api/v3/test.json',
                                     method: :get
    expect { request.run }.to raise_error(BosClient::Error)
  end

  it 'run method result should be hash or raise error' do
    request = BosClient::Request.new BosClient.host, method: :get
    ret = request.run
    expect(ret).to be_a(Hash).or(raise_error(BosClient::Error))
  end
end
