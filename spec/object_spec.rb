require 'spec_helper'
require 'securerandom'
describe BosClient::Object do
  before do
    config_bos_client
    @bucket = BosClient::Bucket.new name:'hdfs'
  end

  it 'can upload as a new file' do
    ret = BosClient::Object.upload file:"Gemfile.lock",filename:"Gemfile.lock",bucket:@bucket
    expect(ret).to eq(true)
  end

  it 'can upload as a new file name' do
    ret = BosClient::Object.upload file:"Gemfile",filename:"Gemfile.#{SecureRandom.hex(3)}",bucket:@bucket
    expect(ret).to eq(true)
  end

  it 'can upload to low frequency' do
    ret = BosClient::Object.upload file:"Gemfile",filename:"#{SecureRandom.hex(3)}.low.frequency",bucket:@bucket, storage_class: "STANDARD_IA"
    expect(ret).to eq(true)
  end

  it 'can upload to a new dir' do
    ret = BosClient::Object.upload file:"Gemfile",filename:"Gemfile.#{SecureRandom.hex(3)}",bucket:@bucket, storage_class: "STANDARD_IA", path: 'tmp/'
    expect(ret).to eq(true)
  end

  it 'object can be destory' do
    BosClient::Object.upload file:"Gemfile",filename:"Gemfile.#{SecureRandom.hex(3)}",bucket:@bucket
    objects = @bucket.objects
    expect(objects.first.destory).to eq(true)
  end

  it 'object can download to current path' do
    result = @bucket.objects
    object = result.first
    object.save
    expect(File.exist?(object.name)).to eq(true)
    File.delete(object.name)
  end

  it 'object can download to a new path' do
    result = @bucket.objects
    object = result.first
    path = 'tmp'
    Dir.mkdir(path) unless File.exists?(path)
    object.save_to 'tmp'
    expect(File.exist?("#{path}/#{object.name}")).to eq(true)
    File.delete("#{path}/#{object.name}")
  end

  it 'object can download with a new filename' do
    result = @bucket.objects
    object = result.first
    object.save_as 'downloadname.0'
    expect(File.exist?("downloadname.0")).to eq(true)
    File.delete("downloadname.0")

    path = 'tmp'
    Dir.mkdir(path) unless File.exists?(path)
    object.save_as 'tmp/downloadname.1'
    expect(File.exist?("tmp/downloadname.1")).to eq(true)
    File.delete("tmp/downloadname.1")
  end

end
