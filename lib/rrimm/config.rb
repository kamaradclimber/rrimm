module RRImm
  class Config
    attr :feeds, :cache
    attr :default_formatter, :pipe

    def initialize
      @feeds = {}
      cache "default cache" do
        path File.join(ENV['HOME'], '.cache', 'rrimm')
      end
      @pipe = "cat"
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

      puts "Default formatter: #{default_formatter}" if default_formatter
      
      puts "Feeds:"
      @feeds.values.group_by { |f| f.category }.map do |cat, feeds|
        if cat.nil? or cat.empty?
          puts ""
        else
          puts "#{cat}:"
        end
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
      new_feed.formatter = default_formatter if default_formatter
      new_feed.pipe = pipe if pipe
      new_feed.instance_eval(&block) if block
      new_feed
    end

    def default_formatter(arg=nil)
      if arg
        @default_formatter = arg
      end
      @default_formatter
    end

    def pipe(arg=nil)
      if arg
        @pipe = arg
      end
      @pipe
    end

    def feed(name, *args, &block)
      feed_def = evaluate_feed_definition(name, *args, &block)
      @feeds[name] = feed_def
    end

    def category(cat_name, &block)
      Feed.module_eval do
        @@tmp_cat_name = cat_name
        alias :old_initialize :initialize
        def initialize(feed_name)
          old_initialize(feed_name)
          @category = @@tmp_cat_name
        end
      end
      self.instance_eval(&block) if block
    ensure
      Feed.module_eval do
        alias :initialize :old_initialize
      end
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
