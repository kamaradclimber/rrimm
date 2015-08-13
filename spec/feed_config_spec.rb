require_relative 'spec_helper'

describe RRImm::FeedConfig do
  describe "#new" do
    it 'uses the name as uri by default' do
      f = RRImm::FeedConfig.new 'a random feed'
      expect(f.name).to eq('a random feed')
      expect(f.uri).to eq('a random feed')
      expect(f.default_name?).to be true
    end

    it 'calls the block if one is specifed' do
      f = RRImm::FeedConfig.new 'a another feed' do
        pipe "cat | cat"
        formatter_class RRImm::ItemFormatter::Mail
      end
      expect(f.pipe).to eq "cat | cat"
      expect(f.formatter_class).to eq RRImm::ItemFormatter::Mail
    end
  end

  describe ".massage" do
    it 'returns argument when no massage' do
      feed = double('test feed')
      f = RRImm::FeedConfig.new 'a random feed'
      expect(f.massage(feed)).to be(feed)
    end
    it 'applies simple massage' do
      feed = (1..5)
      f = RRImm::FeedConfig.new 'a random feed'
      f.massages << {select: Proc.new { |el| el % 2 == 0 }}
      expect(f.massage(feed)).to eq([2,4])
    end
  end

  describe ".format" do
    it 'calls formatter' do
      formatter = double('formatter')
      f = RRImm::FeedConfig.new 'a random feed'
      f.pipe "cat /dev/null"
      f.formatter = formatter
      expect(formatter).to receive(:format)
      expect { f.format(nil, nil) }.not_to raise_error
    end
  end
end

describe RRImm::FeedConfigExtensions do
  describe 'select' do
    it 'applies select on feed' do
      feed = (1..5)
      f = RRImm::FeedConfig.new 'a random feed'
      f.select { |el| el % 2 == 0 }
      expect(f.massage(feed)).to eq([2,4])
    end
  end
end
