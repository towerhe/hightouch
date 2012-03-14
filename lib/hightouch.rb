$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'middleman'
require 'virtus'
require 'thor/group'

require 'hightouch/app_generator'
require 'hightouch/cli'
require 'hightouch/archive_page_generator'

module Hightouch
  autoload :BlogPosting,  'hightouch/blog_posting'
  autoload :Archive,      'hightouch/archive'
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
    include ArchivePageGenerator

    def blog
      @blog ||= Blog.new(self)
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
    def max_tag
      blog.tags.values.max { |x, y| x.count <=> y.count }
    end

    def min_tag
      blog.tags.values.min { |x, y| x.count <=> y.count }
    end
  end
end

Middleman::Extensions.register(:hightouch) { Hightouch }
