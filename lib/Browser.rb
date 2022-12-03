# Browser.rb
# Browser

# 20221203
# 0.1.0

# Changes:
# 1. + .bookmarks_location to all classes except Base
# 2. + .history_location to call classes except Base

# History:
# I realised when wanting to dump all bookmarks from any browsers on one machine for import to another
# that I'd already written something of the sort for history called dump_browser_history_to_csv and
# that it would probably be a good idea to combine those efforts into a single browser library to handle
# both bookmarks and history, as well as any other similar browser data extraction effort.

# Todo:
# 1. Add Opera support.
# 2. Add Linux and Windows support.

require 'pathname'

class Browser
  LIST = %w{
    Brave
    Chrome
    Chromium
    Firefox
    Safari
    TorBrowser
  }

  class Base
    def self.bookmarks_path
      Pathname.new(bookmarks_location)
    end

    def self.history_path
      Pathname.new(history_location)
    end
  end

  class ChromiumBased < Base
    def self.bookmarks_json
      JSON.parse(bookmarks_path)
    end

    def self.history_sql
      'SELECT * FROM urls ORDER BY last_visit_time DESC;'
    end
  end

  class Brave < ChromiumBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/BraveSoftware/Brave-Browser/Default/Bookmarks'
    HISTORY_LOCATION = '~/Library/Application Support/BraveSoftware/Brave-Browser/Default/History'

    def self.bookmarks_location
      BOOKMARKS_LOCATION
    end

    def self.history_location
      HISTORY_LOCATION
    end
  end

  class Chrome < ChromiumBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/Google/Chrome/Default/Bookmarks'
    HISTORY_LOCATION = '~/Library/Application Support/Google/Chrome/Default/History'

    def self.bookmarks_location
      BOOKMARKS_LOCATION
    end

    def self.history_location
      HISTORY_LOCATION
    end
  end

  class Chromium < ChromiumBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/Chromium/Default/Bookmarks'
    HISTORY_LOCATION = '~/Library/Application Support/Chromium/Default/History'

    def self.bookmarks_location
      BOOKMARKS_LOCATION
    end

    def self.history_location
      HISTORY_LOCATION
    end
  end

  class FirefoxBased < Base
    def self.bookmarks_sql
      # 'SELECT * FROM moz_bookmarks ORDER BY ? DESC;'
    end

    def self.history_sql
      # 'SELECT * FROM moz_historyvisits ORDER BY ? DESC;'
    end
  end

  class Firefox < FirefoxBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/Firefox/Profiles/**/places.sqlite'
    HISTORY_LOCATION = '~/Library/Application Support/Firefox/Profiles/**/places.sqlite'

    def self.bookmarks_location
      BOOKMARKS_LOCATION
    end

    def self.history_location
      HISTORY_LOCATION
    end
  end

  class Safari < Base
    BOOKMARKS_LOCATION = '~/Library/Safari/Bookmarks.plist'
    HISTORY_LOCATION = '~/Library/Safari/History.db'

    def self.bookmarks_location
      BOOKMARKS_LOCATION
    end

    def self.history_location
      HISTORY_LOCATION
    end

    def self.history_sql
      'SELECT history_items.id, history_items.url, history_visits.visit_time FROM history_items LEFT JOIN history_visits WHERE history_items.id = history_visits.history_item ORDER BY visit_time DESC;'
    end
  end

  class TorBrowser < FirefoxBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite'
    HISTORY_LOCATION = '~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite'

    def self.bookmarks_location
      BOOKMARKS_LOCATION
    end

    def self.history_location
      HISTORY_LOCATION
    end
  end
end
