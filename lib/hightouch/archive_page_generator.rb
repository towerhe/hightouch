module Hightouch
  module ArchivePageGenerator
    def generate_archive_page(archive)
      template_name = archive.class.name.split(/::/).last.downcase
      page archive.path, proxy: "/templates/#{template_name}.html" do
        @archive_name = archive.name
      end
    end
  end
end
