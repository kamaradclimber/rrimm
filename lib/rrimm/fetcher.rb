require 'rss'
require 'open-uri'

module RRImm
  class Fetcher

    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def fetch
      @config.feeds.map do |feed_config|
        open(feed_config.uri) do |rss|
          feed = RSS::Parser.parse(rss)
          feed.items.each do |item|
            feed_config.format(feed, item)
          end
        end
      end
    end
  end
end
