# Browser/FirefoxBased.rb
# Browser::FirefoxBased

require_relative './Base'

class Browser
  class FirefoxBased < Base
    DEFAULT_PROFILE_NAME = "**"

    class << self
      def bookmarks_location(bookmarks_location: nil, profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path(bookmarks_location || "#{profiles_path}/#{profile_name}/places.sqlite")
      end

      def history_location(history_location: nil, profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path(history_location || "#{profiles_path}/#{profile_name}/places.sqlite")
      end

      private

      def root_path
        raise NotImplementedError, "#{self} must implement root_path"
      end

      def profiles_path
        "#{root_path}/Profiles"
      end

      def bookmarks_format
        :sqlite
      end

      def history_format
        :sqlite
      end

      def bookmarks_sql
        'SELECT * FROM moz_bookmarks ORDER BY ? DESC;'
      end

      def history_sql
        'SELECT * FROM moz_historyvisits ORDER BY ? DESC;'
      end
    end
  end
end
