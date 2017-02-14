require 'spec_helper'
describe Bos::Bucket do
  before do
    config_bos
    @bucket = Bos::Bucket.new name:'hdfs'
    @unexist_bucket = Bos::Bucket.new name:'unexist'
  end

  it 'should return a correct host' do
    expect(@bucket.bucket_host).to eq('http://hdfs.bj.bcebos.com')
  end

  it 'bucket accessable' do
    expect(@bucket.accessable?).to eq(true)
  end

  it 'bucket unaccessable' do
    expect{ @unexist_bucket.accessable? }.to raise_error(Bos::Error)
  end

  it 'bucket list objects' do
    result = @bucket.objects
    expect(result.first).to be_a(Bos::Object)
  end

  it 'bucket list dirs' do
    result =  @bucket.dirs
    expect(result).to be_a(Array)
  end

  it 'bucket list dir objects' do
    result = @bucket.dir_objects 'files/'
    expect(result).to be_a(Array)
    expect(result.first).to be_a(Bos::Object)
  end

  it 'can create a new bucket' do
    new_bucket = Bos::Bucket.new name:'bosgemtest'
    request = Bos::Request.new new_bucket.bucket_host, method: :put
    request.run
  end

  it 'can destory a bucket' do
    new_bucket = Bos::Bucket.new name:'bosgemtest'
    expect(new_bucket.destory).to eq(true)
  end

end
