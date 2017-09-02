module RRImm
  class Publisher
    # will receive in order:
    # - formatted item
    # - raw feed
    # - raw item
    def publish(*args)
      raise "You have to implement this method"
    end
  end
end

require_relative 'publisher/pipe'
require_relative 'publisher/reddit'
