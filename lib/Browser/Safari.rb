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

      # Everything either table holds which a consumer could want, which leaves out
      # the internal keys, domain_expansion, the visit count blobs and their
      # recomputation flag, the two ranking scores, and generation and attributes,
      # all of which are Safari's own bookkeeping.
      def history_sql
        'SELECT history_visits.id, history_items.url, history_visits.title, history_visits.visit_time, history_visits.load_successful, history_visits.http_non_get, history_visits.synthesized, history_visits.redirect_source, history_visits.redirect_destination, history_visits.origin, history_items.visit_count, history_items.status_code FROM history_visits LEFT JOIN history_items ON history_visits.history_item = history_items.id ORDER BY history_visits.visit_time DESC;'
      end

      def visited_at(row)
        HISTORY_EPOCH + row['visit_time']
      end
    end
  end
end
