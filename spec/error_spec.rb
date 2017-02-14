require 'spec_helper'

describe Bos::Error do
  it 'can set an undefine error constant' do
    expect(Bos::Error.const_defined? 'TestError').to eq(false)
    Bos::Error::TestError
    expect(Bos::Error.const_defined? 'TestError').to eq(true)
  end

  it 'Bos::Error::Testerror1 superclass should be Bos::Error' do
    expect(Bos::Error::TestError.superclass).to eq(Bos::Error)
  end

  it 'an undefine error constant should accept a message' do
    error = Bos::Error::TestError2.new "error message"
    expect(error.message).to eq("error message")
  end
end
