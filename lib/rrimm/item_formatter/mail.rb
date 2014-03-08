module RRImm
  module ItemFormatter
    class Mail

      attr_accessor :dest, :sender

      def initialize(hash)
        @dest = hash[:to]
        @sender = hash[:from]
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

      def format(feed, item, feed_config, pipe)
        pipe.write "From: #{from(item)}\n"
        pipe.write "To: #{dest}\n"
        pipe.write "Subject: #{subject(feed, item, feed_config)}\n"
        pipe.write "Content-Type: text/html;\n"
        pipe.write "\n"
        pipe.write item.link
        pipe.write "\n\n"
        pipe.write item.content if item.content
        pipe.write "\n"
      end
    end
  end
end
