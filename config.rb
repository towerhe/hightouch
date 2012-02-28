require 'pry'

require 'lib/hightouch'

activate :blog

Encoding.default_external = 'utf-8'

require "redcarpet"
set :markdown_engine, :redcarpet

require 'rygments'
require 'rack/codehighlighter'

use Rack::Codehighlighter,
  :pygments,
  element: 'code',
  markdown: true,
  pattern: /\A:::([-_+\w]+)\s*\n/

configure :build do; end
