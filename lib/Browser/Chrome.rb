# Browser/Chrome.rb
# Browser::Chrome

require_relative './ChromiumBased'

class Browser
  class Chrome < ChromiumBased
    class << self
      private

      def root_path
        "~/Library/Application Support/Google/Chrome"
      end
    end
  end
end
