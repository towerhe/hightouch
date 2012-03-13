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
    attribute :archive, Archive

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
      @raw = app.frontmatter(path).last

      update_association(Category, page.data.categories) if page.data.categories
      update_association(Tag, page.data.tags) if page.data.tags
      update_archive(@date_created)

      @description = nil
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
    def update_association(type, updated)
      association_name = type.name.split(/::/).last.downcase.pluralize.to_sym
      association = send(association_name)
      association.each do |k, v|
        unless updated.include? k
          association.delete(k).remove_blog_posting(self)
        end
      end

      updated.each do |u|
        a = association[u]
        next if a

        a = blog.send(association_name)[u] || blog.send(:create_archive, type, name: u, blog: blog)

        a.add_blog_posting(self)
        association[u] = a
      end
    end

    def update_archive(date_created)
      name = date_created.strftime('%Y/%m')
      return if archive && archive.name == name

      archive = blog.archives[name] || blog.create_archive(Archive, name: name, blog: blog)
      archive.add_blog_posting(self)
    end
  end
end
