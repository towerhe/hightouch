module Hightouch
  class Category < Archive
    def path
      "/blog/#{name}.html"
    end
  end
end
