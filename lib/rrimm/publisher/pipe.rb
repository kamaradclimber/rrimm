require_relative '../logger'

module RRImm
  class Pipe < Publisher

    include Logger

    def initialize(command)
      super()
      @command = command
    end

    attr_reader :command

    def publish(input, *args)
      cmd = Mixlib::ShellOut.new(command, input: input)
      cmd.run_command
      info cmd.stderr if cmd.error?
      cmd.error!
    end
  end
end
