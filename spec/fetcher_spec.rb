require_relative 'spec_helper'

describe RRImm::Fetcher do
  let(:basic_conf) do
    xkcd_file = File.join(File.dirname(__FILE__), 'xkcd.xml')
    xkcd_uri = 'http://toto.com/xkcd.xml'

    stub_request(:get, xkcd_uri).
      to_return(status: 200, body: File.read(xkcd_file))
    feed = RRImm::FeedConfig.new xkcd_uri do
      pipe 'cat > /dev/null'
    end
    cache = double('cache_mock')
    allow(RRImm::Cache).to receive(:new).and_return(cache)
    allow(cache).to receive(:path)

    allow(cache).to receive(:read).and_return(3829)
    allow(cache).to receive(:save)

    config = RRImm::Config.new
    config.feeds['local_xkcd'] = feed
    config
  end

  describe '#initialize' do
    it 'createscorrectly' do
      expect { RRImm::Fetcher.new(basic_conf, {}) }.not_to raise_error
    end
  end

  describe '#fetch' do
    it 'fetches correctly' do
      fetcher = RRImm::Fetcher.new basic_conf, {}
      expect { fetcher.fetch }.not_to raise_error
    end
    it 'fetches correctly when using concurrency' do
      fetcher = RRImm::Fetcher.new basic_conf, {'concurrency' => 5}
      expect { fetcher.fetch }.not_to raise_error
    end
  end
end
