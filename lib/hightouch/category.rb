module Hightouch
  class Category
    attr_reader :name, :blog_postings

    def initialize(name)
      @name = name
      @blog_postings = {}
    end

    def add_blog_posting(blog_posting)
      blog_postings[blog_posting.url] = blog_posting

      self
    end

    def remove_blog_posting(blog_posting)
      blog_postings.delete(blog_posting.url)

      self
    end
  end
end
