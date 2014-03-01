module RRImm
  module ItemFormatter
    class Mail

      attr_accessor :dest, :sender

      def initialize(dest, sender)
        @dest = dest
        @sender = sender
      end

      def from(item)
        if item.author and item.author.include? '@'
          item.author
        else
          @sender
        end
      end

      def subject(feed, item, feed_config)
        subject = item.title
        subject = "[#{feed_config.category}]#{item.title}" if feed_config.category
        subject
      end

      def format(feed, item, feed_config)
        puts "#{feed.title || feed.channel.title}: #{item.title} (#{item.date})"
        puts "From: #{from(item)}"
        puts "To: #{dest}"
        puts "Subject: #{subject(feed, item, feed_config)}"
        puts ""
        puts item.link
        puts ""
        puts (item.description || item.content)
      end
    end
  end
end
