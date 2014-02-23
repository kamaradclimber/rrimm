module RRImm
  class Config
    attr :feeds

    def initialize
      @feeds = {}
    end

    def feeds
      @feeds
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

  end
end
