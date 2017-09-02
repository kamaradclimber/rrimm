module RRImm
  class Cache

    attr_accessor :name
    attr_accessor :path

    REMOVE_PATTERNS = [
        /^.*:\/\/\/?/,
        /^(http|ftp|file)s?___/,
        /_+$/,
    ]

    INVALID_PATTERNS = [
        /[^\w]/,
    ]

    DEFAULT_TIMESTAMP = 1

    def initialize(name)
       @name = name
       @path = name
    end

    def path(arg=nil)
      if arg
        @path = arg
      end
      @path
    end

    def cache_file(feed)
      filename = sanitize(feed.uri)
      File.join(path, filename)
    end

    def read(feed)
      file_path = cache_file(feed)

      return DEFAULT_TIMESTAMP unless File.exists?(file_path)
      timestamp = File.read(file_path)
      timestamp.to_i
    end

    def save(feed, timestamp, force=true)
      ensure_cache_dir!
      file_path = cache_file(feed)
      File.write(file_path, timestamp) if (force or timestamp != read(feed))
    end

    private
    def sanitize(name)
      cleaned_name = INVALID_PATTERNS.inject(name) do |memo,pattern|
        memo.gsub(pattern, '_')
      end
      REMOVE_PATTERNS.inject(cleaned_name) do |memo,pattern|
        memo.gsub(pattern, '')
      end
    end

    def ensure_cache_dir!
      @cache_dir_exists ||= Dir.exists?(path) || Dir.mkdir(path)
    end
  end
end
