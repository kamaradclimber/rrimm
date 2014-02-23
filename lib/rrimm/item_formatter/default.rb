module RRImm
  module ItemFormatter
    class Default
      def format(feed, item)
        puts "#{feed.channel.title}: #{item.title}"
      end
    end
  end
end
