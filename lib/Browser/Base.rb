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
