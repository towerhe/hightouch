module Hightouch
  module Blog
    class BlogPosting
      attr_reader :name, :url, :description, :keywords

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
        @keywords = page.data.keywords.split(/\s+,\s+/) if page.data.keywords
        @date_created = Date.strptime(page.data.date_created, '%Y/%m/%d') if page.data.date_created
        @author = page.data.author
        @url = '/' + page.path
        @raw = app.frontmatter(path).last

        @article_body = nil
      end

      def article_body
        @article_body ||= page.render(layout: false)
      end
    end
  end
end
