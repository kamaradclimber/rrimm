require 'mixlib/shellout'
require 'stringio'

module RRImm
  class Feed
 
    attr_accessor :name
    attr_accessor :uri
    attr_accessor :formatter_class, :formatter
    attr_accessor :category
    attr_accessor :pipe

    def initialize(name, &block)
      @name = name
      @uri = name
      @formatter_class = RRImm::ItemFormatter::Default
      self.instance_eval(&block) if block
    end

    def format(feed, item)
      @formatter ||= @formatter_class.new
      s = ""
      StringIO.open(s) do |str|
        @formatter.format(feed,item, self, str)
      end
      cmd = Mixlib::ShellOut.new(pipe, :input => s)
      cmd.run_command
      puts cmd.stderr if cmd.error?
      cmd.error!
    end

    def category(arg=nil)
      if arg
        @category = arg
      end
      @category
    end

    def uri(arg=nil)
      if arg
        @uri = arg
      end
      @uri
    end

    def default_name?
      @name.eql? @uri
    end

    def formatter_class(arg=nil)
      if arg
        @formatter_class = arg
      end
      @formatter_class
    end

    def pipe(arg=nil)
      if arg
        @pipe = arg
      end
      @pipe
    end

  end
end
