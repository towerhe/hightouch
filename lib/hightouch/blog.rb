module Hightouch
  class Blog
    include Virtus

    attribute :archive_cache, Hash, default: {}
    attribute :category_cache, Hash, default: {}
    attribute :tag_cache, Hash, default: {}
    attribute :blog_posting_cache, Hash, default: {}

    attr_reader :app

    def initialize(app = nil)
      @app = app
    end

    def archives
      Hash[archive_cache.sort_by { |k, v| v.name }.reverse]
    end

    def categories
      Hash[category_cache.sort_by { |k, v| v.name }]
    end

    def tags
      Hash[tag_cache.sort_by { |k, v| v.name }]
    end

    def blog_postings
      Hash[blog_posting_cache.sort_by { |k, v| v.date_created }.reverse]
    end

    def create_archive(type, attrs)
      send("#{type.name.split(/::/).last.downcase}_cache".to_sym)[attrs[:name]] = type.new(attrs)
    end

    def find_archive(type, key)
      send("#{type.name.split(/::/).last.downcase}_cache".to_sym)[key]
    end

    def remove_archive(archive)
      key = archive.name
      send("#{archive.class.name.split(/::/).last.downcase}_cache".to_sym).delete(key)
    end

    def touch_blog_posting(page)
      key = page.data.title
      blog_posting = blog_posting_cache[key]

      if blog_posting
        blog_posting.update
      else
        blog_posting_cache[key] = BlogPosting.new(page, self)
      end
    end

    def blog_posting(path)
      blog_posting_cache.values.select { |v| v.url == path }.first
    end
  end
end
