require_relative 'spec_helper'


describe RRImm::ItemFormatter::Mail do
  it 'formats correctly xkcd feed' do
    mail_formatter = RRImm::ItemFormatter::Mail.new(
      from: 'from@example.com',
      to: 'to@example.com'
    )
    xkcd_file = File.join('file://', File.dirname(__FILE__), 'xkcd.xml')
    feed = Feedjira::Feed.fetch_and_parse(xkcd_file)
    expect(feed.entries.size).to be > 0
    s = StringIO.new
    config = double('config')
    expect(config).to receive(:category).twice.and_return nil
    expect(config).to receive(:default_name?).and_return(true, false)
    mail_formatter.format(feed, feed.entries.first, config, s)
    expect(s.string).to eq "From: RRImm <from@example.com>\nTo: to@example.com\nDate: Fri, 07 Mar 2014 05:00:00 -0000\nSubject: When You Assume\nContent-Type: text/html;\n\nhttp://xkcd.com/1339/\n\n<img src=\"http://imgs.xkcd.com/comics/when_you_assume.png\" title=\"You know what happens when you assert--you make an ass out of the emergency response team.\" alt=\"You know what happens when you assert--you make an ass out of the emergency response team.\" />\n"
    s = StringIO.new

    expect(config).to receive(:name).and_return "Randall Munroe"
    mail_formatter.format(feed, feed.entries.first, config, s)
  end
end

describe RRImm::ItemFormatter::Default do
  it 'formats correctly xkcd feed' do
    default_formatter = RRImm::ItemFormatter::Default.new
    xkcd_file = File.join('file://', File.dirname(__FILE__), 'xkcd.xml')
    feed = Feedjira::Feed.fetch_and_parse(xkcd_file)
    expect(feed.entries.size).to be > 0
    s = StringIO.new
    default_formatter.format(feed, feed.entries.first, nil, s)
    s.close
    expect(s.string).to eq "xkcd.com: When You Assume (2014-03-07 05:00:00 UTC)\n"
  end
end
