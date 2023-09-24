require_relative './ChromiumBased'

class Browser
  class Brave < ChromiumBased
    PROFILE_ROOT_PATH = "~/Library/Application Support/BraveSoftware/Brave-Browser"
    DEFAULT_PROFILE_NAME = "Default"

    class << self
      def bookmarks_location(profile_name: DEFAULT_PROFILE_NAME, bookmarks_location: nil)
        bookmarks_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/Bookmarks")
      end

      def history_location(profile_name: DEFAULT_PROFILE_NAME, history_location: nil)
        history_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/History")
      end
    end
  end
end
