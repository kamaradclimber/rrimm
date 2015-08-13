require 'mixlib/shellout'
require 'stringio'

module RRImm
  module FeedConfigExtensions

    def select(&block)
      @massages << { select: block}
    end

  end
end

module RRImm
  class FeedConfig
    include FeedConfigExtensions
  end
end
