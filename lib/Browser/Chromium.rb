require_relative './ChromiumBased'

class Browser
  class Chromium < ChromiumBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/Chromium/Default/Bookmarks'
    HISTORY_LOCATION = '~/Library/Application Support/Chromium/Default/History'

    class << self
      def bookmarks_location(bookmarks_location = BOOKMARKS_LOCATION)
        File.expand_path(bookmarks_location)
      end

      def history_location(history_location = HISTORY_LOCATION)
        File.expand_path(history_location)
      end
    end
  end
end
