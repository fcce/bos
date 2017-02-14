require 'spec_helper'
describe Bos::Object do
  before do
    config_bos
    @bucket = Bos::Bucket.new name:'hdfs'
  end

  it 'object can download to current path' do
    result = @bucket.dir_objects 'files/'
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
    result = @bucket.dir_objects 'files/'
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

  it 'object can be destory' do
    result = @bucket.objects
    object = result.first
    expect(object.destory).to eq(true)
  end

end
