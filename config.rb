require 'pry'

require 'lib/hightouch'
activate :hightouch

Encoding.default_external = 'utf-8'

require "redcarpet"
set :markdown_engine, :redcarpet

require 'rygments'
require 'rack/codehighlighter'
page "/blog/*", layout: :blog_postings

use Rack::Codehighlighter,
  :pygments,
  element: 'code',
  markdown: true,
  pattern: /\A:::([-_+\w]+)\s*\n/

configure :build do; end

ready do
  generate_archive_pages
end
