# Browser.rb
# Browser

# 20260822
# 0.7.0

# Changes since 0.6:
# -/0 (Settle how a browser is named and constructed.)
# 1. - Browser, the delegating class, which called class methods removed in 0.6.
# 2. + Browser.new(name): any case, returning an instance of that browser's class.
# 3. ~ Browser::Base: < Browser, so that a browser is_a? Browser.
# 4. /lib/TopLevelBrowser.rb/lib/browser-classes.rb/
# 5. ~ browser-classes.rb: assigns rather than subclasses.
# 6. - Browser::*.bookmarks_location, .history_location: the location arguments.
# 7. ~ Browser::Base#initialize takes them instead.
# 8. ~ Browser::FirefoxBased.bookmarks_sql, .history_sql: + the join to moz_places, which holds the url.
# 9. ~ the same two: + a real column to order by.
# 10. ~ Browser::TorBrowser.profiles_path: Browser rather than Firefox's Profiles.
# 11. ~ Browser::Bookmarks#dump, Browser::History#dump: + filename:, + path:
# 12. ~ the same two: return the path written, and write nothing when the render raises.
# 13. - Browser::History#dump_filename: String#pascalcase, a no-op for every browser name.
# 14. - lib/String/pascalcase.rb, which nothing else required.

# History: I realised when wanting to dump all bookmarks from any browsers on one machine for import to another
# that I'd already written something of the sort for history called dump_browser_history_to_csv and that it
# would probably be a good idea to combine those efforts into a single browser library to handle both bookmarks
# and history, as well as any other similar browser data extraction effort.

# Todo:
# 1. Add Opera support.
# 2. Add Linux and Windows support.

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
  def self.new(name = nil, **options)
    return super(**options) unless self == Browser
    browser_name = LIST.detect{|browser| browser.downcase == name.to_s.downcase.delete('_')}
    raise ArgumentError, "Unknown browser: #{name.inspect}." unless browser_name
    const_get(browser_name).new(**options)
  end
end
