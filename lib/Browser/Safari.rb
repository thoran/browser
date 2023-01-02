require_relative './Base'

class Browser
  class Safari < Base
    BOOKMARKS_LOCATION = '~/Library/Safari/Bookmarks.plist'
    HISTORY_LOCATION = '~/Library/Safari/History.db'

    class << self
      def bookmarks_json(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil
      end

      def bookmarks_location(bookmarks_location = BOOKMARKS_LOCATION)
        File.expand_path(bookmarks_location)
      end

      def bookmarks_plist(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil
      end
      alias_method :bookmarks, :bookmarks_plist

      def bookmarks_sql
        nil
      end

      def history_location(history_location = HISTORY_LOCATION)
        File.expand_path(history_location)
      end

      def history_sql
        'SELECT history_items.id, history_items.url, history_visits.visit_time FROM history_items LEFT JOIN history_visits WHERE history_items.id = history_visits.history_item ORDER BY visit_time DESC;'
      end
    end
  end
end
