# browser-classes.rb

# Instead of writing Browser::Brave.new or Browser.new(:brave), write Brave.new.

require_relative './Browser'

Brave      = Browser::Brave
Chrome     = Browser::Chrome
Chromium   = Browser::Chromium
Firefox    = Browser::Firefox
Safari     = Browser::Safari
TorBrowser = Browser::TorBrowser
