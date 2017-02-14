require 'spec_helper'

describe Bos::Request do
  before do
    config_bos
  end

  it 'run method raise an error' do
    request = Bos::Request.new 'https://ruby-china.org/api/v3/test.json', method: :get
    expect {request.run }.to raise_error(Bos::Error)
  end

  it 'run method result should be hash or raise error' do
    request = Bos::Request.new Bos.host, method: :get
    ret = request.run
    expect(ret).to be_a(Hash).or(raise_error(Bos::Error))
  end

end
