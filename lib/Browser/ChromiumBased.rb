# Browser/ChromiumBased.rb
# Browser::ChromiumBased

require_relative './Base'

class Browser
  class ChromiumBased < Base
    DEFAULT_PROFILE_NAME = "Default"

    class << self
      def bookmarks_location(bookmarks_location: nil, profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path(bookmarks_location || "#{profiles_path}/#{profile_name}/Bookmarks")
      end

      def history_location(history_location: nil, profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path(history_location || "#{profiles_path}/#{profile_name}/History")
      end

      private

      def root_path
        raise NotImplementedError, "#{self} must implement root_path"
      end

      def profiles_path
        root_path
      end

      def bookmarks_format
        :json
      end

      def history_format
        :sqlite
      end

      def bookmarks_sql
        nil
      end

      def history_sql
        'SELECT * FROM urls ORDER BY last_visit_time DESC;'
      end
    end
  end
end
