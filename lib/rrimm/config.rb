module RRImm
  class Config
    attr :feeds, :cache

    def initialize
      @feeds = {}
      cache "default cache" do
        path File.join(ENV['HOME'], '.cache', 'rrimm')
      end
    end

    def feeds
      @feeds
    end

    def get_cache
      @cache
    end

    def show
      puts "Cache: #{@cache.name}"
      puts "  path: #{@cache.path}" unless @cache.path.eql? @cache.name
      
      puts "Feeds:"
      @feeds.values.group_by { |f| f.category }.map do |cat, feeds|
        puts " #{cat}:" unless cat.nil? or cat.empty?
        feeds.each do |feed|
          fqdn = [feed.name]
          fqdn << feed.uri unless feed.name.eql? feed.uri
          puts "- #{fqdn.join ': '}"
        end
      end
    end

    def evaluate_feed_definition(feed_name, &block)
      #this allow to redefine feeds if necessary
      existing_feed = @feeds[feed_name]
      new_feed = (existing_feed || Feed.new(feed_name))
      new_feed.instance_eval(&block) if block
      new_feed
    end

    def feed(name, *args, &block)
      feed_def = evaluate_feed_definition(name, *args, &block)
      @feeds[name] = feed_def
    end

    def load(file)
      instance_eval(File.read(file), file)
    end

    def cache(name, *args, &block)
      @cache = Cache.new name
      @cache.instance_eval(&block) if block
      @cache
    end

  end
end
