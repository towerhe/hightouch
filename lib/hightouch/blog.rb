module Hightouch
  module Blog
    class << self
      def registered(app)
        app.after_configuration do
          def data.blog; @blog ||= Blog.new; end

          frontmatter_changed /blog\/(\d{4})\/(\d{2})\/(\d{2})\/(.*)\.html/ do |file|
            data.blog.touch_blog_posting(self.sitemap.page(self.sitemap.file_to_path(file)))
          end

        end
      end

      alias :included :registered
    end

    class Blog
      attr_reader :blog_postings

      def initialize
        @blog_postings = {}
      end

      def touch_blog_posting(page)
        path = page.path

        if blog_postings.has_key?(path)
          @blog_postings[path].update
        else
          @blog_postings[path] = Hightouch::Blog::BlogPosting.new(page)
        end
      end
    end
  end
end
