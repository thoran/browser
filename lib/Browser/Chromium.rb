# Browser/Chromium.rb
# Browser::Chromium

require_relative './ChromiumBased'

class Browser
  class Chromium < ChromiumBased
    class << self
      private

      def root_path
        "~/Library/Application Support/Chromium"
      end
    end
  end
end
