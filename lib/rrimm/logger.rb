module RRImm
  module Logger

    def info(message)
      puts format_log(message)
    end

    def debug(message)
      puts format_log(message) if ENV['RRIMM_DEBUG']
    end

    def format_log(message)
      "#{Time.now.strftime('%T')} message"
    end
  end
end
