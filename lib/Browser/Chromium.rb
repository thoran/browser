require_relative './ChromiumBased'

class Browser
  class Chromium < ChromiumBased
    DEFAULT_BOOKMARKS_LOCATION = '~/Library/Application Support/Chromium/Default/Bookmarks'
    DEFAULT_HISTORY_LOCATION = '~/Library/Application Support/Chromium/Default/History'

    class << self
      def bookmarks_location(bookmarks_location = DEFAULT_BOOKMARKS_LOCATION)
        File.expand_path(bookmarks_location)
      end

      def history_location(history_location = DEFAULT_HISTORY_LOCATION)
        File.expand_path(history_location)
      end
    end
  end
end
