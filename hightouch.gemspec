$:.push File.expand_path("../lib", __FILE__)

require "hightouch/version"

Gem::Specification.new do |s|
  s.name        = "hightouch"
  s.version     = Hightouch::VERSION
  s.authors     = ["Tower He"]
  s.email       = ["towerhe@gmail.com"]
  s.homepage    = "http://hetao.im"
  s.summary     = "A static site generator based on middleman"
  s.description = "Hightouch(HT) will help you to build your web blog in minutes and with helpers to deploy your site to github pages"

  s.executables = ['hightouch', 'ht']
  s.default_executable = 'hightouch'

  s.files = Dir["{bin,lib,source,spec}/**/*"] +
    ["config.rb", "Gemfile", "Gemfile.lock", "README.md", "rvmrc.example"]

  s.add_dependency "middleman", '>= 3.0.0.beta.1'
  s.add_dependency "rygments", ">= 0.2.0"
  s.add_dependency "rack-codehighlighter", ">= 0.5.0"
  s.add_dependency "redcarpet", ">= 2.0.1"
  s.add_dependency "virtus", ">= 0.3.0"

end
