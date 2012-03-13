module Hightouch
  class Tag < Category
    def path
      "/blog/tags/#{name}.html"
    end
  end
end
