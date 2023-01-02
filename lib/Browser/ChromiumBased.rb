require 'json'
require_relative './Base'

class Browser
  class ChromiumBased < Base
    class << self
      def bookmarks(bookmarks_location = nil)
        JSON.parse(bookmarks_json(bookmarks_location))
      end

      def bookmarks_json(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        File.read(bookmarks_location)
      end

      def history_sql
        'SELECT * FROM urls ORDER BY last_visit_time DESC;'
      end
    end
  end
end
