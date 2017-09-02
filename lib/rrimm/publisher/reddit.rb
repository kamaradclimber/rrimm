module RRImm
  class Reddit < Publisher
    def initialize
      require 'redd' # avoid requirment if necessary HACK

      # patch redd to allow creating subreddits
      Redd::Models::Subreddit.class_eval do
        def create(**params)
          @client.post('/api/site_admin', params)
        end
      end

      @subreddits = {}
    end

    attr_reader :subreddits

    def feed2sr(feed)
      "rss_#{feed.title.gsub(/[\. ]+/, '')}"
    end

    def publish(input, feed, item)
      subreddit = subreddits[feed.title] || check_subreddit!(feed)
      subreddits[feed.title] = subreddit
      puts "Will submit #{item.title} (from #{feed.title}) to #{subreddit.display_name}"
      subreddit.submit(item.title, url: item.url)
    end


    def check_subreddit!(feed)
      begin
        sr(feed2sr(feed)).tap { |s| s.subscribe }
      rescue Redd::NotFound
        create_subreddit!(feed)
        retry
      end
    end

    def create_subreddit!(feed)
      puts "Will create subreddit named #{feed2sr(feed)}"
      sr(feed2sr(feed)).create(
        allow_discovery: true,
        allow_images: true,
        allow_top: true,
        allow_videos: true,
        api_type: 'json',
        collapse_deleted_comments: true,
        comment_score_hide_mins: 0,
        description: "RSS feed from #{feed.url} posted by RRImm",
        exclude_banned_modqueue: true,
        free_form_reports: false,
        "header-title": "RSS feed from #{feed.url} posted by RRImm",
        hide_ads: false,
        lang: 'FR-fr',
        link_type: 'link',
        name: feed2sr(feed),
        over_18: false,
        public_description: "RSS feed from #{feed.url} posted by RRImm",
        show_media: true,
        show_media_preview: true,
        spam_comments: 'high',
        spam_links: 'high',
        spam_selfposts: 'high',
        spoilers_enabled: false,
        submit_link_label: "This reddit is not made to posted to by humans",
        submit_text: "This reddit is not made to posted to by humans",
        submit_text_label: "This reddit is not made to posted to by humans",
        suggested_comment_sort: "confidence",
        title: "RSS feed from #{feed.url} posted by RRImm",
        type: "public",
        wiki_edit_age: 0,
        wiki_edit_karma: 100,
        wikimode: 'disabled'
        )
    end

    def sr(name)
      reddit.subreddit(name)
    end

    def reddit
      @reddit ||= Redd.it(
        user_agent: 'Redd:RRImm:v1.0.0 (by /u/kamaradclimber)',
        client_id: ENV['REDDIT_CLIENT_ID'],
        secret: ENV['REDDIT_SECRET'],
        username: ENV['REDDIT_USERNAME'],
        password: ENV['REDDIT_PASSWORD']
      )
    end
  end
end
