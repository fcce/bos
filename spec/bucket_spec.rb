require 'spec_helper'
require 'securerandom'
describe BosClient::Bucket do
  before do
    config_bos_client
    @bucket = BosClient::Bucket.new name: 'hdfs'
    @unexist_bucket = BosClient::Bucket.new name: 'unexist'
    @bucket_random_name = "gemtest#{SecureRandom.hex(3)}"
  end

  it 'should return a correct host' do
    expect(@bucket.bucket_host).to eq('http://hdfs.bj.bcebos.com')
  end

  it 'bucket accessable' do
    expect(@bucket.accessable?).to eq(true)
  end

  it 'bucket unaccessable' do
    expect { @unexist_bucket.accessable? }.to raise_error(BosClient::Error)
  end

  it 'bucket list objects' do
    result = @bucket.objects
    expect(result.first).to be_a(BosClient::Object)
  end

  it 'bucket list dirs' do
    result = @bucket.dirs
    expect(result).to be_a(Array)
  end

  it 'bucket list dir objects' do
    BosClient::Object.upload  file: 'Gemfile',
                              filename: "Gemfile.#{SecureRandom.hex(3)}",
                              bucket: @bucket,
                              storage_class: 'STANDARD_IA',
                              path: 'tmp/'
    result = @bucket.dir_objects 'tmp/'
    expect(result).to be_a(Array)
    expect(result.first).to be_a(BosClient::Object)
  end

  #TODO: use travis will baidu give a 400 error
  it 'can create a new bucket and can be destory' do
    new_bucket = BosClient::Bucket.new name: @bucket_random_name
    expect(new_bucket.save).to eq(true)
    expect(new_bucket.destory).to eq(true)
  end
end
