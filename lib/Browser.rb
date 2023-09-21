# Browser.rb
# Browser

# 20230921
# 0.4.1

# Changes since 0.3:
# -/0
# 1. + Browser::History
# 0/1
# 2. ~ ChromiumBased subclasses: /BOOKMARKS_LOCATION/DEFAULT_BOOKMARKS_LOCATION/
# 3. ~ ChromiumBased subclasses: /HISTORY_LOCATION/DEFAULT_HISTORY_LOCATION/

# History:
# I realised when wanting to dump all bookmarks from any browsers on one machine for import to another
# that I'd already written something of the sort for history called dump_browser_history_to_csv and
# that it would probably be a good idea to combine those efforts into a single browser library to handle
# both bookmarks and history, as well as any other similar browser data extraction effort.

# Todo:
# 1. Add Opera support.
# 2. Add Linux and Windows support.

require 'Object/to_const'
require 'String/camelcase'

class Browser
  LIST = %w{
    Brave
    Chrome
    Chromium
    Firefox
    Safari
    TorBrowser
  }
end

Browser::LIST.each do |browser|
  browser_filename = File.expand_path("#{__FILE__}/../Browser/#{browser}")
  require browser_filename
end

class Browser
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
    delegate.class.bookmarks_plist(@bookmarks_location)
  end

  def bookmarks_sql
    delegate.class.bookmarks_sql
  end

  def history_sql
    delegate.class.history_sql
  end

  def history
    delegate.class.history(@history_location)
  end

  private

  def delegate
    @delegate ||= "Browser::#{@name.camelcase}".to_const.new(
      bookmarks_location: @bookmarks_location,
      history_location: @history_location
    )
  end
end
