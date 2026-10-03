# Browser/Base.rb
# Browser::Base

require_relative './Bookmarks'
require_relative './History'

class Browser
  class Base < Browser
    class << self
      def default_profile_name
        self::DEFAULT_PROFILE_NAME
      end

      # The directory the profile sits in, which a Selenium front end wants in place
      # of a throwaway one.  A browser which keeps no profiles has no such directory,
      # and says so with nil rather than with a path.
      def profile_path(profile_name: nil)
        return nil unless profiles_path
        profile_name ||= default_profile_name
        File.expand_path("#{profiles_path}/#{profile_name}")
      end
    end

    def bookmarks
      Browser::Bookmarks.new(self)
    end

    def history
      Browser::History.new(self)
    end

    # Each is what was given, or else derived when first wanted, so that making a
    # browser costs nothing and a default which has to be looked up is looked up
    # only for a read.
    def profile_name
      @profile_name ||= self.class.default_profile_name
    end

    def bookmarks_location
      @bookmarks_location ||= self.class.bookmarks_location(profile_name: profile_name)
    end

    def history_location
      @history_location ||= self.class.history_location(profile_name: profile_name)
    end

    # Derived from the profile name alone, which has done any looking up already, and
    # never given, so there is nothing here to hold on to.
    def profile_path
      self.class.profile_path(profile_name: profile_name)
    end

    def name
      self.class.to_s.split('::').last
    end

    private

    def initialize(bookmarks_location: nil, history_location: nil, profile_name: nil)
      @bookmarks_location = bookmarks_location
      @history_location = history_location
      @profile_name = profile_name
    end
  end
end
