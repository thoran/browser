require 'json'
require_relative './Base'

class Browser
  class ChromiumBased < Base
    class << self
      def bookmarks_json(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        JSON.parse(File.read(bookmarks_location))
      end
      alias_method :bookmarks, :bookmarks_json

      def history_sql
        'SELECT * FROM urls ORDER BY last_visit_time DESC;'
      end
    end
  end
end
