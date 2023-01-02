# Browser.rb
# Browser

# 20230102
# 0.3.1

# Changes:
# 1. Moved Browser::Base to own file.
# 2. Moved Browser::Brave to own file.
# 3. Moved Browser::Chrome to own file.
# 4. Moved Browser::Chromium to own file.
# 5. Moved Browser::ChromiumBased to own file.
# 6. Moved Browser::Firefox to own file.
# 7. Moved Browser::FirefoxBased to own file.
# 8. Moved Browser::Safari to own file.
# 9. Moved Browser::TorBrowser to own file.
# 10. + TopLevelBrowser.rb.
# 11. Moved tests to Browser directory.
# 12. + Firefox test.
# 13. + Safari test.
# 14. + TorBrowser test.
# 0/1
# 15. Made the tests uniform.

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
