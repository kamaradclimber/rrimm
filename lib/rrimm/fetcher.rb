require 'rss'
require 'open-uri'
require 'open_uri_redirections'

module RSS
  module Atom
    class Feed
      class Updated
        def to_date
          @content
        end
      end
    end
  end
end

module RRImm
  class Fetcher

    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def fetch
      @config.feeds.map do |name,feed_config|
        last_read = Time.at(@config.get_cache.read(feed_config))
        open(feed_config.uri, :allow_redirections => :safe) do |rss|
          feed = RSS::Parser.parse(rss)
          items = feed.items.select { |item| (item.date || item.updated.to_date) > last_read }
          last_read = items.collect { |item| item.date }.max unless items.empty?
          items.each do |item|
            feed_config.format(feed, item)
          end
        end
        @config.get_cache.save(feed_config, last_read.to_i)
      end
    end
  end
end
