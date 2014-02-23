module RRImm
  module ItemFormatter
    class Default
      def format(feed, item)
        puts "#{feed.channel.title}: #{item.title} (#{item.date})"
      end
    end
  end
end
