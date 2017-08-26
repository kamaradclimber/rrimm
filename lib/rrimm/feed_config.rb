require 'mixlib/shellout'
require 'stringio'

module RRImm
  class FeedConfig
 
    attr_accessor :name
    attr_accessor :uri
    attr_accessor :formatter_class, :formatter
    attr_accessor :category
    attr_accessor :publisher
    attr_accessor :massages

    def initialize(name, &block)
      @name = name
      @uri = name
      @formatter_class = RRImm::ItemFormatter::Default
      @massages = []
      self.instance_eval(&block) if block
    end

    # may apply modifications on feeds
    # must return an enumerable of feeditems
    # massage method applies @massages keys as methods on "feed"
    # it also uses the value as a block if a block is given
    def massage(feed)
      @massages.inject(feed) do |mem, method_with_arg|
        arg = method_with_arg.values.first
        method = method_with_arg.keys.first
        if arg
          mem.send(method, &arg)
        else
          mem.send(method)
        end
      end
    end

    def format(feed, item)
      @formatter ||= @formatter_class.new
      s = ""
      StringIO.open(s) do |str|
        @formatter.format(feed,item, self, str)
      end
      publisher.publish(s)
    end

    def category(arg=nil)
      if arg
        @category = arg
      end
      @category
    end

    def uri(arg=nil)
      if arg
        @uri = arg
      end
      @uri
    end

    def default_name?
      @name.eql? @uri
    end

    def formatter_class(arg=nil)
      if arg
        @formatter_class = arg
      end
      @formatter_class
    end

    def publisher(arg=nil)
      if arg
        @publisher = arg
      end
      @publisher
    end

    # compat with old pipe
    def pipe(arg=nil)
      if arg
        publisher RRImm::Pipe.new(arg)
      end
      publisher.command
    end

  end
end
