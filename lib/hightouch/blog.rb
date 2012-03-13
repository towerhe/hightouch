module Hightouch
  class Blog
    include Virtus

    attribute :archives, Hash, default: {}
    attribute :categories, Hash, default: {}
    attribute :tags, Hash, default: {}
    attribute :blog_postings, Hash, default: {}

    attr_reader :app

    def initialize(app = nil)
      @app = app
    end

    def create_archive(type, attrs)
      send(type.name.split(/::/).last.downcase.pluralize.to_sym)[attrs[:name]] = type.new(attrs)
    end

    def remove_archive(archive)
      key = archive.name
      send(archive.class.name.split(/::/).last.downcase.pluralize.to_sym).delete(key)
    end

    def touch_blog_posting(page)
      key = page.data.title
      blog_posting = blog_postings[key]

      if blog_posting
        blog_posting.update
      else
        blog_postings[key] = BlogPosting.new(page, self)
      end
    end

    def blog_posting(path)
      blog_postings.values.select { |v| v.url == path }.first
    end
  end
end
