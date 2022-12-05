# Browser.rb
# Browser

# 20221203, 04, 05
# 0.2.0

# Changes:
# 1. + Browser class from dump_browser_history_to_csv.
# 2. + BOOKMARKS_LOCATION data from Bookmarks.
# 3. + Browser::Base
# 4. /Browser::AVAILABLE_BROSWERS/Browser::LIST/

# History:
# I realised when wanting to dump all bookmarks from any browsers on one machine for import to another
# that I'd already written something of the sort for history called dump_browser_history_to_csv and
# that it would probably be a good idea to combine those efforts into a single browser library to handle
# both bookmarks and history, as well as any other similar browser data extraction effort.

# Todo:
# 1. Add Opera support.
# 2. Add Linux and Windows support.

require 'json'
require 'Object/to_const'
require 'pathname'
require 'shellwords'

class String
  def camelcase
    if self.match?(/_/)
      self.split('_').collect{|e| e.capitalize}.join
    else
      self
    end
  end
end

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
    class << self
      def bookmarks(bookmarks_location = nil)
        raise 'No concrete implementation for .bookmarks.'
      end

      def bookmarks_json(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil
      end

      def bookmarks_location
        raise 'No concrete implementation for .bookmarks_location.'
      end

      def bookmarks_plist(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil
      end

      def bookmarks_sql
        nil
      end

      def history_location
        raise 'No concrete implementation for .history_location.'
      end

      def history_sql
        raise 'No concrete implementation for .history_sql.'
      end
    end
  end

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

  class Brave < ChromiumBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/BraveSoftware/Brave-Browser/Default/Bookmarks'
    HISTORY_LOCATION = '~/Library/Application Support/BraveSoftware/Brave-Browser/Default/History'

    class << self
      def bookmarks_location(bookmarks_location = BOOKMARKS_LOCATION)
        File.expand_path(bookmarks_location)
      end

      def history_location(history_location = HISTORY_LOCATION)
        File.expand_path(history_location)
      end
    end
  end

  class Chrome < ChromiumBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/Google/Chrome/Default/Bookmarks'
    HISTORY_LOCATION = '~/Library/Application Support/Google/Chrome/Default/History'

    class << self
      def bookmarks_location(bookmarks_location = BOOKMARKS_LOCATION)
        File.expand_path(bookmarks_location)
      end

      def history_location(history_location = HISTORY_LOCATION)
        File.expand_path(history_location)
      end
    end
  end

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

  class TorBrowser < FirefoxBased
    BOOKMARKS_LOCATION = '~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite'
    HISTORY_LOCATION = '~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite'

    class << self
      def bookmarks_location(bookmarks_location = BOOKMARKS_LOCATION)
        File.expand_path(bookmarks_location)
      end

      def history_location(history_location = HISTORY_LOCATION)
        File.expand_path(history_location)
      end
    end
  end

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

  attr_accessor :name
  attr_accessor :bookmarks_location
  attr_accessor :history_location

  def initialize(name, options = {})
    @name = name
    @bookmarks_location = options[:bookmarks_location]
    @history_location = options[:history_location]
  end

  def bookmarks
    delegate.class.bookmarks(@bookmarks_location)
  end

  def bookmarks_json
    delegate.class.bookmarks_json(@bookmarks_location)
  end

  def bookmarks_plist
    delegate.class.bookmarks_plist
  end

  def bookmarks_sql
    delegate.class.bookmarks_sql
  end

  def history_sql
    delegate.class.history_sql
  end

  private

  def delegate
    @delegate ||= "Browser::#{@name.camelcase}".to_const.new
  end
end
