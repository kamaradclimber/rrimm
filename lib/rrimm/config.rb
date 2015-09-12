require 'colorize'

module RRImm
  class Config
    attr :feeds, :cache
    attr :default_formatter, :pipe
    attr_accessor :output

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

    def show(ios, category=nil)
      ios.write "Cache: #{@cache.name}\n"
      ios.write "  path: #{@cache.path}\n" unless @cache.path.eql? @cache.name

      ios.write "Default formatter: #{default_formatter}\n" if default_formatter
      
      ios.write "Feeds:\n"
      @feeds.values.
        group_by { |f| f.category }.
        select { |cat, feeds| category.nil? || cat == category }.
        map do |cat, feeds|
        ios.write "#{cat || "unamed category"}:\n"
        feeds.each do |feed|
          fqdn = [feed.name, feed.uri].uniq
          ios.write "- #{fqdn.join ': '}\n"
        end
      end
    end

    def reset_caches(timestamp)
      @feeds.each do |name, f|
        if get_cache.read(f) > timestamp
          get_cache.save(f, timestamp)
          puts "Reset #{name}"
        end
      end
    end

    def status(ios, old_timestamp, very_old_timestamp, display_old_only, category=nil)
      @feeds.values.
        select { |f| category.nil? || f.category == category }.
        map { |f| [ Time.at(get_cache.read(f)), f] }.
        sort_by { |el| el.first }.
        each do |el|
          date, f = el
          case date.to_i
          when 0..very_old_timestamp
            ios.write "#{date} #{f.name}\n".red
          when very_old_timestamp..old_timestamp
            ios.write "#{date} #{f.name}\n".yellow
          else
            ios.write "#{date} #{f.name}\n".green unless display_old_only
          end
        end
    end

    def evaluate_feed_definition(feed_name, &block)
      #this allow to redefine feeds if necessary
      existing_feed = @feeds[feed_name]
      new_feed = (existing_feed || FeedConfig.new(feed_name))
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
      FeedConfig.module_eval do
        @@tmp_cat_name = cat_name
        alias :old_initialize :initialize
        def initialize(feed_name)
          old_initialize(feed_name)
          @category = @@tmp_cat_name
        end
      end
      self.instance_eval(&block) if block
    ensure
      FeedConfig.module_eval do
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
