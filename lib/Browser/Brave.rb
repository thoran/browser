# Browser/Brave.rb
# Browser::Brave

require_relative './ChromiumBased'

class Browser
  class Brave < ChromiumBased
    class << self
      private

      def root_path
        "~/Library/Application Support/BraveSoftware/Brave-Browser"
      end
    end
  end
end
