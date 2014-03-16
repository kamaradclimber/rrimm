require_relative 'spec_helper'

describe RRImm::Config do
  describe "#load" do
    it 'loads feeds properly' do
      conf = RRImm::Config.new
      expect(conf.feeds.size).to be 0
      conf.load(File.join(File.dirname(__FILE__), '..', 'examples', 'most_simple_config.rb'))
      expect(conf.feeds.size).to be 2
    end

    it 'displays config properly' do
      ios = StringIO.new
      conf = RRImm::Config.new
      expect{ conf.show(ios) }.not_to raise_error
      expect(ios.string).to include "default cache"
    end

    it 'prints status properly' do
      cache = double('cache')
      allow(cache).to receive(:read).and_return(1, 4, 7)
      allow(cache).to receive(:path)
      ios = StringIO.new
      allow(RRImm::Cache).to receive(:new).and_return(cache)
      conf = RRImm::Config.new
      conf.feeds['1_very_old'] = RRImm::Feed.new 'very_old'
      conf.feeds['3_old'] = RRImm::Feed.new 'old'
      conf.feeds['7_recent'] = RRImm::Feed.new 'recent'
      expect{ conf.status(ios, 5, 3, false) }.not_to raise_error
      expect(ios.string).to include "#{Time.at(1)} very_old\n".red
      expect(ios.string).to include "#{Time.at(4)} old\n".yellow
      expect(ios.string).to include "#{Time.at(7)} recent\n".green
    end
  end
end
