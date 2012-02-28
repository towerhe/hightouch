$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'hightouch/blog_posting'
require 'hightouch/blog'

Middleman::Extensions.register(:blog) do
  Hightouch::Blog
end
