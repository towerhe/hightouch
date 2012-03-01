module Hightouch
  class Tag < Category
    def initialize(name, blog)
      @name = name
      @blog = blog
      @blog_postings = {}

      blog.add_tag(self)
    end
  end
end
