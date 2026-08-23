# Browser/FirefoxBased.rb
# Browser::FirefoxBased

require_relative './Base'

class Browser
  class FirefoxBased < Base
    # A profile directory is named for a hash, so there is no fixed default.  This
    # is a glob, which File.expand_path does not expand: supply a profile name, or a
    # location, to reach a particular profile.
    DEFAULT_PROFILE_NAME = "**"

    class << self
      def bookmarks_location(profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path("#{profiles_path}/#{profile_name}/places.sqlite")
      end

      def history_location(profile_name: nil)
        profile_name ||= DEFAULT_PROFILE_NAME
        File.expand_path("#{profiles_path}/#{profile_name}/places.sqlite")
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
        'SELECT moz_bookmarks.id, moz_places.url, moz_bookmarks.title, moz_bookmarks.dateAdded FROM moz_bookmarks LEFT JOIN moz_places ON moz_bookmarks.fk = moz_places.id WHERE moz_bookmarks.type = 1 ORDER BY moz_bookmarks.dateAdded DESC;'
      end

      def history_sql
        'SELECT moz_historyvisits.id, moz_places.url, moz_places.title, moz_historyvisits.visit_date FROM moz_historyvisits LEFT JOIN moz_places ON moz_historyvisits.place_id = moz_places.id ORDER BY moz_historyvisits.visit_date DESC;'
      end
    end
  end
end
