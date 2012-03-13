module Hightouch
  class Blog
    include Virtus

    attribute :categories, Hash, default: {}
    attribute :tags, Hash, default: {}
    attribute :blog_postings, Hash, default: {}

    attr_reader :app

    def initialize(app = nil)
      @app = app
    end

    def create_category(attrs)
      categories[attrs[:name]] = Category.new(attrs)
    end

    def remove_category(category)
      key = category.is_a?(String) ? category : category.name

      categories.delete(key)
    end

    def create_tag(attrs)
      tags[attrs[:name]] = Tag.new(attrs)
    end

    def remove_tag(tag)
      key = tag.is_a?(String) ? tag : tag.name

      tags.delete(key)
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
      path.sub!(/^\//, "")
      blog_postings[path]
    end
  end
end
