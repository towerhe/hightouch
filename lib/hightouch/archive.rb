module Hightouch
  class Archive
    include Virtus

    attribute :name, String
    attribute :blog, Blog
    attribute :blog_posting_cache, Hash, default: {}

    def blog_postings
      Hash[blog_posting_cache.sort_by { |k, v| v.date_created }.reverse]
    end

    def add_blog_posting(blog_posting)
      blog_posting_cache[blog_posting.name] = blog_posting
    end

    def remove_blog_posting(blog_posting)
      blog_posting_cache.delete(blog_posting.name)
      blog.remove_archive(self) if empty?
    end

    def empty?
      blog_posting_cache.empty?
    end

    def count
      blog_posting_cache.size
    end

    def path
      "/blog/#{name}/index.html"
    end
  end
end
