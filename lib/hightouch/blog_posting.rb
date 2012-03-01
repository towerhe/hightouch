module Hightouch
  module Blog
    class BlogPosting
      DESC_SEPARATOR = /READMORE/
      attr_reader :blog

      attr_reader :name, :url, :description, :tags, :categories

      # TODO Create a class Person
      attr_reader :author

      attr_reader :date_created, :date_modified, :date_published

      attr_reader :raw, :page

      def initialize(page, blog)
        @blog = blog
        @page = page

        @categories = []
        @tags = []

        update
      end

      def update
        app = page.store.app
        path = page.source_file.sub(app.source_dir, '')

        @name = page.data.title

        @date_created = Date.strptime(page.data.date_created, '%Y/%m/%d') if page.data.date_created
        @author = page.data.author
        @url = '/' + page.path
        @description = page.data.description
        @raw = app.frontmatter(path).last

        update_categories(page.data.categories) if page.data.categories
        update_tags(page.data.tags) if page.data.tags

        @article_body = nil
      end

      def article_body
        @article_body ||= begin
                            body = page.render(layout: false)
                            body.sub!(DESC_SEPARATOR, '')
                          end
      end

      def description
        @description ||= begin
                           desc = if raw =~ DESC_SEPARATOR
                                    raw.split(DESC_SEPARATOR).first
                                  else
                                    raw.match(/(.{1,200}.*?)(\n|\Z)/m).to_s
                                  end
                           engine = ::Tilt[page.source_file].new { desc }
                           engine.render
                         end

      end

      private
      def update_categories(updated)
        add_to_categories(updated - @categories)
        remove_from_categories(@categories - updated)
        
        @categories = updated
      end

      def add_to_categories(added)
        added.each do |c|
          category = blog.has_category?(c) ? blog.find_category(c) : Category.new(c, blog)

          category.add_blog_posting(self)
        end
      end

      def remove_from_categories(removed)
        removed.each do |c|
          category = blog.find_category(c)

          category.remove_blog_posting(self) if category
        end
      end

      def update_tags(updated)
        add_to_tags(updated - @tags)
        remove_from_tags(@tags - updated)
        
        @tags = updated
      end

      def add_to_tags(added)
        added.each do |c|
          tag = blog.has_tag?(c) ? blog.find_tag(c) : Tag.new(c, blog)

          tag.add_blog_posting(self)
        end
      end

      def remove_from_tags(removed)
        removed.each do |c|
          tag = blog.find_tag(c)

          tag.remove_blog_posting(self) if tag 
        end
      end
    end
  end
end
