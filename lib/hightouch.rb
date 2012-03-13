$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'virtus'

module Hightouch
  autoload :BlogPosting,  'hightouch/blog_posting'
  autoload :Category,     'hightouch/category'
  autoload :Tag,          'hightouch/tag'
  autoload :Blog,         'hightouch/blog'

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

  module HelperMethods
    def blog
      @blog ||= Blog.new(self)
    end

    def generate_category_pages
      blog.categories.each do |k, v|
        generate_category_page(k)
      end
    end

    def generate_tag_pages
      blog.tags.each do |k, v|
        generate_tag_page(k)
      end
    end

    def font_size_for_tag(tag, opts = {})
      max_font_size = opts[:max_font_size] || 36
      min_font_size = opts[:min_font_size] || 11

      max_count = max_tag.count
      min_count = min_tag.count

      size = begin
               if max_count == min_count
                 min_font_size
               else
                 min_font_size + (max_count - (max_count - (tag.count - min_count))) * (max_font_size - min_font_size).to_f/(max_count - min_count).to_f
               end
             end
    end

    private
    def generate_category_page(category)
      name = category.is_a?(String) ? category : category.name
      page "/blog/#{name}.html", proxy: "/blog/category.html", ignore: true do
        @category_name = name
      end
    end

    def generate_tag_page(tag)
      name = tag.is_a?(String) ? tag : tag.name
      page "/blog/tags/#{name}.html", proxy: "/blog/tags/tag.html", ignore: true do
        @tag_name = name
      end
    end

    def max_tag
      blog.tags.values.max { |x, y| x.count <=> y.count }
    end

    def min_tag
      blog.tags.values.min { |x, y| x.count <=> y.count }
    end


  end
end

Middleman::Extensions.register(:hightouch) { Hightouch }
