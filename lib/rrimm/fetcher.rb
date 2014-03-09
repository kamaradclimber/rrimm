require 'feedzirra'
require 'open-uri'
require 'open_uri_redirections'
require 'parallel'

module RRImm
  class Fetcher

    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def fetch(concurrency=nil)
      if concurrency
        parallel_fetch(concurrency)
      else
        linear_fetch
      end
    end

    def parallel_fetch(concurrency)
      Parallel.map(@config.feeds, :in_threads => concurrency) do |name,feed_config|
        fetch_feed(name, feed_config)
      end
    end

    def linear_fetch
      @config.feeds.map do |name,feed_config|
        fetch_feed(name, feed_config)
      end
    end

    def fetch_feed(name, feed_config)
      last_read = Time.at(@config.get_cache.read(feed_config))
      puts name
      feed = Feedzirra::Feed.fetch_and_parse(feed_config.uri)
      items = feed.entries.select { |item| item.published > last_read }
      last_read = items.collect { |item| item.published }.max unless items.empty?
      items.each do |item|
        feed_config.format(feed, item)
      end
      @config.get_cache.save(feed_config, last_read.to_i)
    end
  end
end
