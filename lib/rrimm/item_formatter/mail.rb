module RRImm
  module ItemFormatter
    class Mail

      attr_accessor :dest, :sender

      def initialize(hash)
        @dest = hash[:to]
        @sender = hash[:from]
      end

      def default_author(feed_config)
        if feed_config.default_name?
          "RRImm <#{@sender}>"
        else
          "#{feed_config.name} <#{@sender}>"
        end
      end

      def from(authors)
        authors.compact.select { |a| a.include? '@' }.first
      end

      def subject(feed, item, feed_config)
        subject = item.title
        subject = "[#{feed_config.category}]#{item.title}" if feed_config.category
        subject
      end

      def format(feed, item, feed_config, pipe)
        pipe.write "From: #{from [item.author, default_author(feed_config)]}\n"
        pipe.write "To: #{dest}\n"
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
