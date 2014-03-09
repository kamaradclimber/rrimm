module RRImm
  module ItemFormatter
    class Default
      def format(feed, item, feed_config, pipe)
        pipe.write "#{feed.title}: #{item.title} (#{item.published})"
        pipe.write "\n"
      end
    end
  end
end
