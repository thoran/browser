require_relative './FirefoxBased'

class Browser
  class TorBrowser < FirefoxBased
    PROFILE_ROOT_PATH = '~/Library/Application Support/TorBrowser-Data/Profiles'
    DEFAULT_PROFILE_NAME = "**"

    class << self
      def bookmarks_location(profile_name: nil, bookmarks_location: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        bookmarks_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/places.sqlite")
      end

      def history_location(profile_name: nil, history_location: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        history_location ||= File.expand_path("#{PROFILE_ROOT_PATH}/#{profile_name}/places.sqlite")
      end
    end
  end
end
