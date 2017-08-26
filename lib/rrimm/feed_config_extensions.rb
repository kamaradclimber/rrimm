require 'mixlib/shellout'
require 'stringio'

module RRImm
  module FeedConfigExtensions

    def method_missing(name, *args, &block)
      if Enumerable.instance_methods(false).include? name
        @massages << { name => block }
      else
        raise NoMethodError, "#{name} does not exist"
      end
      self
    end

  end
end

module RRImm
  class FeedConfig
    include FeedConfigExtensions
  end
end
