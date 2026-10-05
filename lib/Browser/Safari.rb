# Browser/Safari.rb
# Browser::Safari

require_relative './Base'

class Browser
  class Safari < Base
    DEFAULT_PROFILE_NAME = nil # Safari doesn't have profiles.
    HISTORY_EPOCH = Time.utc(2001) # Safari counts seconds from here.

    class << self
      def bookmarks_location(profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path("#{root_path}/Bookmarks.plist")
      end

      def history_location(profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path("#{root_path}/History.db")
      end

      private

      def root_path
        "~/Library/Safari"
      end

      def profiles_path
        nil # Safari doesn't have profiles.
      end

      def bookmarks_format
        :plist
      end

      def history_format
        :sqlite
      end

      def bookmarks_sql
        nil
      end

      def history_sql
        'SELECT history_items.id, history_items.url, history_visits.visit_time FROM history_items LEFT JOIN history_visits WHERE history_items.id = history_visits.history_item ORDER BY visit_time DESC;'
      end

      def visited_at(row)
        HISTORY_EPOCH + row['visit_time']
      end
    end
  end
end
