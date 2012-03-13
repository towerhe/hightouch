module Hightouch
  class CLI < Thor
    argument :name

    desc 'new', 'Creates a hightouch application'
    def new
      AppGenerator.start(["#{Dir.pwd}/#{name}"])
    end
  end
end
