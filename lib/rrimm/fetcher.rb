require 'feedjira'
require 'open-uri'
require 'open_uri_redirections'
require 'parallel'
require 'timeout'

module RRImm
  class Fetcher

    attr_accessor :config, :options

    def initialize(config, options)
      @config  = config
      @options = options
      @quiet = options['quiet']
      @category = options['category']
    end

    def fetch()
      if options['concurrency']
        parallel_fetch
      else
        linear_fetch
      end
    end

    def parallel_fetch
      Parallel.map(feeds, :in_threads => options['concurrency'], :progress => "fetching") do |name,feed_config|
        @quiet = true
        fetch_feed(name, feed_config)
      end
    end

    def linear_fetch
      feeds.map do |name,feed_config|
        fetch_feed(name, feed_config)
      end
    end

    def feeds
      @config.feeds.select { |f,conf| @category.nil? || conf.category == @category }
    end

    def debug(message)
      puts message if options['verbose']
    end

    def fetch_feed(name, feed_config)
      begin
        Timeout::timeout(30) do
          fetch_feed_no_timeout(name, feed_config)
        end
      rescue Timeout::Error
        puts "#{name} timeout after 30 seconds"
      end
    end

    def fetch_feed_no_timeout(name, feed_config)
      debug "-> #{name}: reading cache"
      last_read = Time.at(@config.get_cache.read(feed_config))
      print name unless @quiet
      debug "-> #{name}: fetching and parsing"
      feed = Feedjira::Feed.fetch_and_parse(feed_config.uri)
      debug "-> #{name}: fetched and parsed (#{feed.class})"
      if feed.respond_to? :entries
        items = feed.entries.select { |item| item.published > last_read }
        last_read = items.collect { |item| item.published }.max unless items.empty?
        feed_config.massage(items).each do |item|
          debug "-> #{name}: format an item"
          feed_config.format(feed, item)
        end
        debug "-> #{name}: saving cache"
        @config.get_cache.save(feed_config, last_read.to_i, false)
      end
      puts " (#{items.size rescue nil})" unless @quiet
    end
  end
end
