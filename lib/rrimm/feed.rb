module RRImm
  class Feed
 
    attr_accessor :name
    attr_accessor :uri
    attr_accessor :formatter_class, :formatter
    attr_accessor :category
    attr_accessor :pipe

    def initialize(name)
      @name = name
      @uri = name
      @formatter_class = RRImm::ItemFormatter::Default
    end

    def format(feed, item)
      @formatter ||= @formatter_class.new
      cmd = %Q<#{pipe}>
      IO.popen(cmd,'w+') do |pipe|
        @formatter.format(feed, item, self, pipe)
        pipe.close_write
        pipe.read.split("\n").each { |l| puts l }
      end
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

    def pipe(arg=nil)
      if arg
        @pipe = arg
      end
      @pipe
    end

  end
end
