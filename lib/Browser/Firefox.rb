# Browser/Firefox.rb
# Browser::Firefox

require_relative './FirefoxBased'

class Browser
  class Firefox < FirefoxBased
    class << self
      private

      def root_path
        "~/Library/Application Support/Firefox"
      end
    end
  end
end
