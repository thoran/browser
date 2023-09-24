require_relative './FirefoxBased'

class Browser
  class Firefox < FirefoxBased
    PROFILE_ROOT_PATH = "~/Library/Application Support/Firefox/Profiles"
    DEFAULT_PROFILE_NAME = "**"

    class << self
      def bookmarks_location(profile_name: DEFAULT_PROFILE_NAME, bookmarks_location: nil)
        bookmarks_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/places.sqlite")
      end

      def history_location(profile_name: DEFAULT_PROFILE_NAME, history_location: nil)
        history_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/places.sqlite")
      end
    end
  end
end
