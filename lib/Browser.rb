# Browser.rb
# Browser

# 20230924
# 0.5.1

# Changes since 0.3:
# -/0 (Use a supplied profile name to determine bookmarks and history locations.)
# 1. ~ Browser#initialize: + profile_name
# 2. + Browser#bookmarks_location, so that it may be derived from the profile name in the concrete classes.
# 3. + Browser#history_location, so that it may be derived from the profile name in the concrete classes.
# 4. ~ Browser#delegate: + profile_name
# 5. ~ Browser::Base#initialize: + profile_name
# 6. ~ Browser::Brave#bookmarks_location: + profile_name
# 7. ~ Browser::Brave#history_location: + profile_name
# 8. ~ Browser::Chrome#bookmarks_location: + profile_name
# 9. ~ Browser::Chrome#history_location: + profile_name
# 10. ~ Browser::Chromium#bookmarks_location: + profile_name
# 11. ~ Browser::Chromium#history_location: + profile_name
# 12. ~ Browser::Firefox#bookmarks_location: + profile_name
# 13. ~ Browser::Firefox#history_location: + profile_name
# 14. ~ Browser::Safari#bookmarks_location: + profile_name
# 15. ~ Browser::Safari#history_location: + profile_name
# 16. ~ Browser::TorBrowser#bookmarks_location: + profile_name
# 17. ~ Browser::TorBrowser#history_location: + profile_name
# 0/1 (Using the DEFAULT_PROFILE_NAME as the default value for the profile_name argument doesn't seem to work, so assigning the default value in a separate line.)
# 18. ~ Browser::Brave#bookmarks_location: /DEFAULT_PROFILE_NAME/nil/
# 19. ~ Browser::Brave#history_location: /DEFAULT_PROFILE_NAME/nil/
# 20. ~ Browser::Chrome#bookmarks_location: /DEFAULT_PROFILE_NAME/nil/
# 21. ~ Browser::Chrome#history_location: /DEFAULT_PROFILE_NAME/nil/
# 22. ~ Browser::Chromium#bookmarks_location: /DEFAULT_PROFILE_NAME/nil/
# 23. ~ Browser::Chromium#history_location: /DEFAULT_PROFILE_NAME/nil/
# 24. ~ Browser::Firefox#bookmarks_location: /DEFAULT_PROFILE_NAME/nil/
# 25. ~ Browser::Firefox#history_location: /DEFAULT_PROFILE_NAME/nil/
# 26. ~ Browser::Safari#bookmarks_location: /DEFAULT_PROFILE_NAME/nil/
# 27. ~ Browser::Safari#history_location: /DEFAULT_PROFILE_NAME/nil/
# 28. ~ Browser::TorBrowser#bookmarks_location: /DEFAULT_PROFILE_NAME/nil/
# 29. ~ Browser::TorBrowser#history_location: /DEFAULT_PROFILE_NAME/nil/

# History:
# I realised when wanting to dump all bookmarks from any browsers on one machine for import to another
# that I'd already written something of the sort for history called dump_browser_history_to_csv and
# that it would probably be a good idea to combine those efforts into a single browser library to handle
# both bookmarks and history, as well as any other similar browser data extraction effort.

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
    delegate.class.bookmarks(bookmarks_location)
  end

  def bookmarks_json
    delegate.class.bookmarks_json(bookmarks_location)
  end

  def bookmarks_plist
    delegate.class.bookmarks_plist(bookmarks_location)
  end

  def bookmarks_sql
    delegate.class.bookmarks_sql
  end

  def history_sql
    delegate.class.history_sql
  end

  def history
    delegate.class.history(history_location)
  end

  private

  def delegate_class
    "Browser::#{@name.pascalcase}".to_const
  end

  def delegate
    @delegate ||= delegate_class.new(
      bookmarks_location: bookmarks_location,
      history_location: history_location,
      profile_name: profile_name
    )
  end
end
