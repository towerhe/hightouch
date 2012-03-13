module Hightouch
  class AppGenerator < ::Thor::Group
    include ::Thor::Actions

    argument :path

    def self.source_root
      File.join(File.dirname(__FILE__), '../../')
    end

    def create_app_dir
      empty_directory(path)
    end

    def create_files
      directory 'source', "#{path}/source"

      copy_file 'config.rb', "#{path}/config.rb"
      copy_file 'Gemfile', "#{path}/Gemfile"
      copy_file 'Gemfile.lock', "#{path}/Gemfile.lock"
      copy_file 'README.md', "#{path}/README.md"
      copy_file 'rvmrc.example', "#{path}/rvmrc.example"
    end
  end
end
