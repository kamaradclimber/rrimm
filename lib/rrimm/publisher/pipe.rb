module RRImm
  class Pipe < Publisher
    def initialize(command)
      super()
      @command = command
    end

    attr_reader :command

    def publish(input)
      cmd = Mixlib::ShellOut.new(command, input: input)
      cmd.run_command
      puts cmd.stderr if cmd.error?
      cmd.error!
    end
  end
end
