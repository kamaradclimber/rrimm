require_relative 'spec_helper'

describe RRImm::Config do
  describe "#load" do
    it 'loads feeds properly' do
      conf = RRImm::Config.new
      expect(conf.feeds.size).to be 0
      conf.load(File.join(File.dirname(__FILE__), '..', 'examples', 'most_simple_config.rb'))
      expect(conf.feeds.size).to be 2
    end
  end
end
