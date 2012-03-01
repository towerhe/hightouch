module Hightouch
  module Blog
    class BlogPosting
      DESC_SEPARATOR = /READMORE/
      attr_reader :name, :url, :description, :keywords, :categories

      # TODO Create a class Person
      attr_reader :author

      attr_reader :date_created, :date_modified, :date_published

      attr_reader :raw, :page

      def initialize(page)
        @page = page

        update
      end

      def update
        app = page.store.app
        path = page.source_file.sub(app.source_dir, '')

        @name = page.data.title
        @keywords = page.data.keywords.split(/\s+, \s+/) if page.data.keywords
        @categories = page.data.categories
        @date_created = Date.strptime(page.data.date_created, '%Y/%m/%d') if page.data.date_created
        @author = page.data.author
        @url = '/' + page.path
        @description = page.data.description
        @raw = app.frontmatter(path).last

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
    end
  end
end
