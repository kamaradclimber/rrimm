require 'rspec'
require_relative '../lib/rrimm'

describe RRImm::Feed do
  it 'uses the name as uri by default' do
    f = RRImm::Feed.new 'a random feed'
    expect(f.name).to eq('a random feed')
    expect(f.uri).to eq('a random feed')
  end
end
