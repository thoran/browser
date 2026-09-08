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

      # Tor Browser keeps its profiles under Browser where Firefox uses Profiles.
      def profiles_path
        "#{root_path}/Browser"
      end

      # And its profiles.ini beside them, where Firefox keeps its own beside Profiles.
      def profiles_ini_path
        File.expand_path("#{profiles_path}/profiles.ini")
      end
    end
  end
end
