module RRImm
  class Feed
 
    attr_accessor :name
    attr_accessor :uri
    attr_accessor :formatter_class, :formatter
    attr_accessor :category

    def initialize(name)
      @name = name
      @uri = name
      @formatter_class = RRImm::ItemFormatter::Default
    end

    def format(feed, item)
      @formatter ||= @formatter_class.new
      @formatter.format(feed, item, self)
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

    def formatter_class(arg=nil)
      if arg
        @formatter_class = arg
      end
      @formatter_class
    end

  end
end
