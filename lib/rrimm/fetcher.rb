require 'rss'
require 'open-uri'
require 'open_uri_redirections'
require 'parallel'

module RRImm
  class Fetcher

    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def parallel_fetch(concurrency)
      Parallel.map(@config.feeds, :in_threads => concurrency) do |name,feed_config|
        fetch_feed(name, feed_config)
      end
    end

    def fetch
      @config.feeds.map do |name,feed_config|
        fetch_feed(name, feed_config)
      end
    end

    def fetch_feed(name, feed_config)
      last_read = Time.at(@config.get_cache.read(feed_config))
      puts name
      open(feed_config.uri, :allow_redirections => :safe) do |rss|
        feed = RSS::Parser.parse(rss)
        feed = GenericFeed.new feed
        items = feed.items.select { |item| item.date > last_read }
        last_read = items.collect { |item| item.date }.max unless items.empty?
        items.each do |item|
          feed_config.format(feed, item)
        end
      end
      @config.get_cache.save(feed_config, last_read.to_i)
    end
  end
end
