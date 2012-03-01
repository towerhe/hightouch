$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'hightouch/blog_posting'
require 'hightouch/category'
require 'hightouch/tag'
require 'hightouch/blog'

Middleman::Extensions.register(:hightouch) { Hightouch::Blog }
