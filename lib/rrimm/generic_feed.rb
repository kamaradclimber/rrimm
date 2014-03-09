module RRImm
  class GenericFeed
    def initialize(feed)
      @underlying = feed
      @title = feed.title
      @items = feed.entries.map {|item| GenericItem.new item }
    end

    attr_accessor :underlying
    attr_accessor :title

    attr_accessor :items


  end
end
