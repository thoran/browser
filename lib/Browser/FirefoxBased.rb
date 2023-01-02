require_relative './Base'

class Browser
  class FirefoxBased < Base
    class << self
      def bookmarks(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil # FIXME: Should not be nil in time...
      end

      def bookmarks_json(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil # FIXME?: Maybe should not be nil in time...
      end

      def bookmarks_plist(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil # FIXME?: Maybe should not be nil in time...
      end

      def bookmarks_sql
        'SELECT * FROM moz_bookmarks ORDER BY ? DESC;'
      end

      def history_sql
        'SELECT * FROM moz_historyvisits ORDER BY ? DESC;'
      end
    end
  end
end
