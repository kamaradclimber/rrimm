require_relative 'spec_helper'
require 'tmpdir'

describe RRImm::Cache do
  describe '#new' do
    it 'uses the name as default path' do
      cache = RRImm::Cache.new 'default location'
      expect(cache.path).to eq 'default location'
    end
  end

  it 'reads default timestamp if cache is not present' do
    feed = RRImm::Feed.new 'http://kernel.org/rss'
    Dir.mktmpdir do |dir|
      cache = RRImm::Cache.new dir
      expect(cache.read(feed)).to eq RRImm::Cache::DEFAULT_TIMESTAMP
    end
  end

  it 'reads the correct timestamp' do
    feed = RRImm::Feed.new 'http://kernel.org/rss'
    now = Time.now.to_i
    Dir.mktmpdir do |dir|
      cache = RRImm::Cache.new dir
      cache.save(feed, now)
      expect(cache.read(feed)).to eq now
    end
  end
end
