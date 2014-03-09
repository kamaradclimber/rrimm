module RRImm
  class GenericItem
    def initialize(item)
      @underlying = item
      @date = item.published
      @title = item.title
      @link = item.url
      @content = (item.content || item.summary)
      @author = item.author
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
