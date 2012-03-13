module Hightouch
  class Category
    include Virtus

    attribute :name, String
    attribute :blog, Blog
    attribute :blog_postings, Hash, default: {}

    def add_blog_posting(blog_posting)
      blog_postings[blog_posting.name] = blog_posting
    end

    def remove_blog_posting(blog_posting)
      blog_postings.delete(blog_posting.name)
      blog.remove_category(self) if empty?
    end

    def empty?
      blog_postings.empty?
    end

    def count
      blog_postings.size
    end
  end
end
