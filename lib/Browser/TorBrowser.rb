# Browser/TorBrowser.rb
# Browser::TorBrowser

require_relative './FirefoxBased'

class Browser
  class TorBrowser < FirefoxBased
    class << self
      private

      def root_path
        "~/Library/Application Support/TorBrowser-Data"
      end
    end
  end
end
