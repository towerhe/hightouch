module Hightouch
  module ArchivePageGenerator
    def generate_archive_pages
      [:categories, :tags, :archives].each do |i|
        blog.send(i).each do |k, v|
          template_name = v.class.name.split(/::/).last.downcase
          page v.path, proxy: "/templates/archive.html", ignore: true do
            @collection = i
            @archive_name = v.name
          end
        end
      end
    end
  end
end
