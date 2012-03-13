module Hightouch
  class BlogPosting
    include Virtus

    DESC_SEPARATOR = /READMORE/

    attribute :blog, Blog

    attribute :name, String
    attribute :url, String
    attribute :description, String
    attribute :author, String
    attribute :date_created, Date
    attribute :tags, Hash, default: {}
    attribute :categories, Hash, default: {}

    attr_reader :raw, :page

    def initialize(page, blog)
      @blog = blog
      @page = page

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

      update_association(:categories, page.data.categories) if page.data.categories
      update_association(:tags, page.data.tags) if page.data.tags

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
    def update_association(name, updated)
      association = send(name)
      association.each do |k, v|
        unless updated.include? k
          association.delete(k).remove_blog_posting(self)
        end
      end

      updated.each do |u|
        a = association[u]
        next if a

        a = blog.send(name)[u] || blog.send("create_#{name.to_s.singularize}".to_sym, name: u, blog: blog)

        a.add_blog_posting(self)
        association[u] = a
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
