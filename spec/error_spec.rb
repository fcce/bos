require 'spec_helper'

describe BosClient::Error do
  it 'can set an undefine error constant' do
    expect(BosClient::Error.const_defined? 'TestError').to eq(false)
    BosClient::Error::TestError
    expect(BosClient::Error.const_defined? 'TestError').to eq(true)
  end

  it 'BosClient::Error::Testerror1 superclass should be BosClient::Error' do
    expect(BosClient::Error::TestError.superclass).to eq(BosClient::Error)
  end

  it 'an undefine error constant should accept a message' do
    error = BosClient::Error::TestError2.new "error message"
    expect(error.message).to eq("error message")
  end
end
