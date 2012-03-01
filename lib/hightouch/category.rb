module Hightouch
  class Category
    attr_reader :name, :blog, :blog_postings

    def initialize(name, blog)
      @name = name
      @blog = blog
      @blog_postings = {}

      blog.add_category(self)
    end

    def add_blog_posting(blog_posting)
      blog_postings[blog_posting.url] = blog_posting

      self
    end

    def remove_blog_posting(blog_posting)
      blog_postings.delete(blog_posting.url)
      blog.remove_category(self) if empty?

      self
    end

    def empty?
      blog_postings.empty?
    end
  end
end
