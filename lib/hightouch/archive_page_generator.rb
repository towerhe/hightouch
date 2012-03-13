module Hightouch
  module ArchivePageGenerator
    def generate_archive_page(archive)
      page archive.path, proxy: "/templates/archive.html", ignore: true do
        @collection = archive.class.name.split(/::/).last.downcase.pluralize.to_sym
        @archive_name = archive.name
      end
    end
  end
end
