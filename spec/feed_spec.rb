require_relative 'spec_helper'

describe RRImm::Feed do
  describe "#new" do
    it 'uses the name as uri by default' do
      f = RRImm::Feed.new 'a random feed'
      expect(f.name).to eq('a random feed')
      expect(f.uri).to eq('a random feed')
      expect(f.default_name?).to be true
    end

    it 'calls the block if one is specifed' do
      f = RRImm::Feed.new 'a another feed' do
        pipe "cat | cat"
        formatter_class RRImm::ItemFormatter::Mail
      end
      expect(f.pipe).to eq "cat | cat"
      expect(f.formatter_class).to eq RRImm::ItemFormatter::Mail
    end
  end

  describe ".format" do
    it 'calls formatter' do
      formatter = double('formatter')
      f = RRImm::Feed.new 'a random feed'
      f.pipe "cat /dev/null"
      f.formatter = formatter
      expect(formatter).to receive(:format)
      expect { f.format(nil, nil) }.not_to raise_error
    end
  end
end
