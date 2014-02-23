require 'rspec'
require_relative '../lib/rrimm'

describe RRImm::Feed do
  describe "#new" do
    it 'uses the name as uri by default' do
      f = RRImm::Feed.new 'a random feed'
      expect(f.name).to eq('a random feed')
      expect(f.uri).to eq('a random feed')
    end
  end

  describe '#cache_name' do
    it 'cleans leading protocols' do
      %w(http://example.org file://my_homy_feed).each do |f|
        feed = RRImm::Feed.new f
        expect(feed.cache_name).not_to include('http://')
        expect(feed.cache_name).not_to include('file://')
      end
    end
  end
end
