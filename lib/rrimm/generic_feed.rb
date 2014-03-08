module RRImm
  class GenericFeed
    def initialize(feed)
      @underlying = feed
      @items = feed.items.map {|item| GenericItem.new item }
      case feed
      when RSS::Rss
        @title = feed.channel.title
      when RSS::Atom
      end
    end

    attr_accessor :underlying
    attr_accessor :title

    attr_accessor :items


  end
end
