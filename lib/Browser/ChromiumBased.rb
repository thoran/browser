# Browser/ChromiumBased.rb
# Browser::ChromiumBased

require_relative './Base'

class Browser
  class ChromiumBased < Base
    DEFAULT_PROFILE_NAME = "Default"
    HISTORY_EPOCH = Time.utc(1601) # Chromium counts microseconds from here.

    class << self
      def bookmarks_location(profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path("#{profiles_path}/#{profile_name}/Bookmarks")
      end

      def history_location(profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path("#{profiles_path}/#{profile_name}/History")
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

      def visited_at(row)
        HISTORY_EPOCH + Rational(row['last_visit_time'], 1_000_000)
      end
    end
  end
end
