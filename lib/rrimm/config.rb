module RRImm
  class Config
    attr_accessor :feeds

    def initialize
      @feeds = [
        Feed.new("http://planet.haskell.org/rss20.xml"),
        Feed.new("http://xkcd.com/rss.xml")
      ]
    end

    def feeds
      @feeds
    end

  end
end
