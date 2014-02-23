module RRImm
  class Cache

    attr_accessor :name
    attr_accessor :path

    REMOVE_PATTERNS = [
        /^.*:\/\/\/?/,
    ]

    INVALID_PATTERNS = [
        /[&?=]/,
        /\//,
    ]

    def initialize(name)
       @name = name
    end

    def path(arg=nil)
      if arg
        @path = arg
      end
      @path
    end

  end
end
