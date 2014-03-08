module RRImm
  class GenericItem
    def initialize(item)
      @underlying = item
      case item
      when RSS::Rss::Channel::Item
        @date = item.date
        @title = item.title
        @link = item.link
        @content = item.description
        @author = item.author
      when RSS::Atom::Feed::Entry
        @date = item.date || item.updated.content
        @title = item.title.content
        @link = item.link
        @content = item.content
        @author = item.author
      else
        puts item.class
        fail "Please code this case !"
        @updated_date = item.updated_date
        @content = item.content
      end
    end

    attr_accessor :underlying

    attr_accessor :title
    attr :updated_date, :date
    attr_accessor :link
    attr_accessor :content
    attr_accessor :author

    def date
      @updated_date || @date
    end
  end
end
