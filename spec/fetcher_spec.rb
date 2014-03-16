require_relative 'spec_helper'



describe RRImm::Fetcher do
  describe '#initialize' do
    it 'fetches correctly' do
      xkcd_file = File.join('file://', File.dirname(__FILE__), 'xkcd.xml')
      feed = RRImm::Feed.new xkcd_file do
        pipe 'cat > /dev/null'
      end
      cache = double('cache_mock')
      allow(RRImm::Cache).to receive(:new).and_return(cache)
      allow(cache).to receive(:path)

      allow(cache).to receive(:read).and_return(3829)
      allow(cache).to receive(:save)

      config = RRImm::Config.new
      config.feeds['local_xkcd'] = feed
      
      fetcher = RRImm::Fetcher.new config


      expect { fetcher.fetch }.not_to raise_error
    end
  end
end
