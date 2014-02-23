module RRImm
  module ItemFormatter
    class Default
      def format(feed, item, feed_config)
        puts "#{feed.channel.title}: #{item.title} (#{item.date})"
      end
    end
  end
end
