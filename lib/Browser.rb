# Browser.rb
# Browser

# 20250922, 23, 24, 25
# 0.6.0

# Changes since 0.5:
# -/0: + Bookmarks
# 1. + Browser::Bookmarks.from_json, .from_plist, .from_sqlite
# 2. + Browser::Bookmarks: CSV, JSON, Plist, Objects, nested
# 3. + Browser::Bookmarks#to_csv, #to_json, #to_plist, #to_objects
# 4. + Browser::Bookmarks#dump(format), #dump_filename
# 5. + Browser::History: the same four renderers, nested
# 6. + Browser::History#to_json, #to_plist, #to_objects
# 7. + Browser::Base#bookmarks, #history
# 8. - Browser::Base.bookmarks, .bookmarks_json, .bookmarks_plist, .bookmarks_sql
# 9. - Browser::Base.bookmarks_location, .history_location, .history_sql, .history
# 10. - Browser::Base#history_sql
# 11. ~ Browser::Base#initialize: + DEFAULT_PROFILE_NAME where none is given
# 12. + ChromiumBased, FirefoxBased, Safari: root_path, profiles_path, private
# 13. + ChromiumBased, FirefoxBased, Safari: .bookmarks_format, .history_format
# 14. + ChromiumBased, FirefoxBased, Safari: DEFAULT_PROFILE_NAME, Default, ** and nil
# 15. - ChromiumBased, FirefoxBased, Safari: .bookmarks, .bookmarks_json, .bookmarks_plist
# 16. ~ Brave, Chrome, Chromium, Firefox, TorBrowser: root_path, in place of PROFILE_ROOT_PATH
# 17. ~ Safari: root_path, in place of BOOKMARKS_LOCATION and HISTORY_LOCATION
# 18. private throughout lib: 20 in 12 files, where there had been 2 in 2
# 19. + browser.gemspec
# 20. ~ Gemfile: gemspec, in place of the three gems listed
# 21. ~ test/Browser/Brave_test.rb: converted to the reworked API
# 22. ~ the other five tests: .bookmarks_location, .history_location, in place of PROFILE_ROOT_PATH
# 23. ~ lib/Browser.rb: /Changes since 0.4/Changes since 0.5/
# 24. ~ Browser#history: + a bookmarks location, both words misspelt

# History: I realised when wanting to dump all bookmarks from any browsers on one machine for import to another
# that I'd already written something of the sort for history called dump_browser_history_to_csv and that it
# would probably be a good idea to combine those efforts into a single browser library to handle both bookmarks
# and history, as well as any other similar browser data extraction effort.

# Todo:
# 1. Add Opera support.
# 2. Add Linux and Windows support.

require 'Object/to_const'
require 'String/pascalcase'

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
  attr_accessor :profile_name

  def initialize(name, options = {})
    @name = name
    @bookmarks_location = options[:bookmarks_location]
    @history_location = options[:history_location]
    @profile_name = options[:profile_name]
  end

  def bookmarks_location
    @bookmarks_location || delegate_class.bookmarks_location(
      profile_name: @profile_name,
      bookmarks_location: @bookmarks_location
    )
  end

  def history_location
    @history_location || delegate_class.history_location(
      profile_name: @profile_name,
      history_location: @history_location
    )
  end

  def bookmarks
    delegate_class.bookmarks(bookmarks_location)
  end

  def bookmarks_json
    delegate_class.bookmarks_json(bookmarks_location)
  end

  def bookmarks_plist
    delegate_class.bookmarks_plist(bookmarks_location)
  end

  def bookmarks_sql
    delegate_class.bookmarks_sql
  end

  def history_sql
    delegate_class.history_sql
  end

  def history
    delegate_class.history(boomarks_location: bookmakrk_location, history_location: history_location, profile_name: @profile_name)
  end

  private

  def delegate_class
    "Browser::#{@name.pascalcase}".to_const
  end
end
