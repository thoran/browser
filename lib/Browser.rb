# Browser.rb
# Browser

# 20260823
# 0.8.0

# Changes since 0.7:
# -/0 (Make reading trustworthy, and say so when it is not.)
# 1. + lib/Browser/Unreadable.rb: Browser::Unreadable
# 2. ~ Browser::Bookmarks#results, Browser::History#results: rescue IOError, SystemCallError, SQLite3::Exception into it.
# 3. + Browser::Bookmarks#readable?, Browser::History#readable?
# 4. + test/fixtures/FirefoxBased_places.sqlite
# 5. + Rakefile: a task building it.
# 6. ~ test/Browser/Firefox_test.rb, TorBrowser_test.rb
# 7. + tests for #readable? and Browser::Unreadable
# 8. ~ lib/Browser.rb: /Changes since 0.6/Changes since 0.7/

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
