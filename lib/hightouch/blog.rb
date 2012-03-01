module Hightouch
  module Blog
    class << self
      def registered(app)
        app.helpers HelperMethods
        app.helpers ActiveSupport::Inflector

        app.after_configuration do
          frontmatter_changed /blog\/(\d{4})\/(\d{2})\/(\d{2})\/(.*)\.html/ do |file|
            blog.touch_blog_posting(self.sitemap.page(self.sitemap.file_to_path(file)))
          end
        end
      end

      alias :included :registered
    end

    class Blog
      attr_reader :categories, :blog_postings

      def initialize
        @categories = {}
        @blog_postings = {}
      end

      def touch_blog_posting(page)
        path = page.path

        if blog_postings.has_key?(path)
          @blog_postings[path].update

          # TODO Update categories
        else
          blog_posting = Hightouch::Blog::BlogPosting.new(page)
          @blog_postings[path] = blog_posting
          add_to_categories(blog_posting)
        end
      end

      def blog_posting(path)
        path.sub!(/^\//, "")
        @blog_postings[path]
      end

      private
      def add_to_categories(blog_posting)
        blog_posting.categories.each do |c|
          category = categories[c]

          unless category
            categories[c] = Category.new(c)
            category = categories[c]
          end

          category.add_blog_posting(blog_posting)
        end
      end
    end

    module HelperMethods
      def blog
        @blog ||= Blog.new
      end
    end
  end
end
