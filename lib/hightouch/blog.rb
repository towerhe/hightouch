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
      attr_reader :app, :categories, :blog_postings

      def initialize(app)
        @app = app
        @categories = {}
        @blog_postings = {}
      end

      def generate_category_pages
        @categories.each do |k, v|
          generate_category_page(k)
        end
      end

      def generate_category_page(category)
        name = category.is_a?(String) ? category : category.name
        app.page "/blog/#{name}.html", proxy: "/blog/category.html", ignore: true do
          @category_name = name
        end
      end

      def find_category(category)
        @categories[category]
      end

      def add_category(category)
        @categories[category.name] = category
        generate_category_page(category)
      end

      def remove_category(category)
        key = category.is_a?(String) ? category : category.name

        @categories.delete(key)
      end

      def has_category?(category)
        key = category.is_a?(String) ? category : category.name

        @categories.has_key?(key)
      end

      def touch_blog_posting(page)
        path = page.path

        if blog_postings.has_key?(path)
          @blog_postings[path].update
        else
          @blog_postings[path] = BlogPosting.new(page, self)
        end
      end

      def blog_posting(path)
        path.sub!(/^\//, "")
        blog_postings[path]
      end
    end

    module HelperMethods
      def blog
        @blog ||= Blog.new(self)
      end
    end
  end
end
