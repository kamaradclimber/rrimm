module RRImm
  class Feed
 
    attr_accessor :uri
    attr_accessor :formatter_class, :formatter

    def initialize(uri)
      @uri = uri
      @formatter_class = RRImm::ItemFormatter::Default
    end

    def format(feed, item)
      @formatter ||= @formatter_class.new
      @formatter.format(feed, item)
    end
  end
end
