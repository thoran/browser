require_relative './ChromiumBased'

class Browser
  class Chromium < ChromiumBased
    PROFILE_ROOT_PATH = "~/Library/Application Support/Chromium"
    DEFAULT_PROFILE_NAME = "Default"

    class << self
      def bookmarks_location(profile_name: nil, bookmarks_location: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        bookmarks_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/Bookmarks")
      end

      def history_location(profile_name: nil, history_location: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        history_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/History")
      end
    end
  end
end
