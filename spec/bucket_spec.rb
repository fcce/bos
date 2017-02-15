require 'spec_helper'
require 'securerandom'
describe Bos::Bucket do
  before do
    config_bos
    @bucket = Bos::Bucket.new name:'hdfs'
    @unexist_bucket = Bos::Bucket.new name:'unexist'
    @bucket_random_name = "gemtest#{SecureRandom.hex(3)}"
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
    Bos::Object.upload file:"Gemfile",filename:"Gemfile.#{SecureRandom.hex(3)}",bucket:@bucket, storage_class: "STANDARD_IA", path: 'tmp/'
    result = @bucket.dir_objects 'tmp/'
    expect(result).to be_a(Array)
    expect(result.first).to be_a(Bos::Object)
  end

  # TODO use travis will baidu give a 400 error
  # it 'can create a new bucket and can be destory' do
  #   new_bucket = Bos::Bucket.new name: @bucket_random_name
  #   request = Bos::Request.new new_bucket.bucket_host, method: :put
  #   request.run
  #   expect(new_bucket.destory).to eq(true)
  # end

end
