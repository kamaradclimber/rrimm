module RRImm
  module ItemFormatter
    class Mail

      attr_accessor :dest, :sender

      def initialize(hash)
        @dest = hash[:to]
        @sender = hash[:from]
      end

      def guess_author(feed_config, item_author)
        name = "RRImm"
        name = feed_config.name unless feed_config.default_name?
        name = item.author if item_author
        if name.include? '@'
          name
        else
          "#{name} <#{@sender}>"
        end
      end

      def subject(feed, item, feed_config)
        subject = item.title
        subject = "[#{feed_config.category}]#{item.title}" if feed_config.category
        subject
      end

      def format(feed, item, feed_config, pipe)
        pipe.write "From: #{guess_author(feed_config, item.author)}\n"
        pipe.write "To: #{dest}\n"
        pipe.write "Date: #{item.published.rfc2822}\n"
        pipe.write "Subject: #{subject(feed, item, feed_config)}\n"
        pipe.write "Content-Type: text/html;\n"
        pipe.write "\n"
        pipe.write item.url
        pipe.write "\n\n"
        pipe.write (item.content || item.summary)
        pipe.write "\n"
      end
    end
  end
end
