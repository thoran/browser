require_relative './FirefoxBased'

class Browser
  class Firefox < FirefoxBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/Firefox/Profiles/**/places.sqlite'
    HISTORY_LOCATION = '~/Library/Application Support/Firefox/Profiles/**/places.sqlite'

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
