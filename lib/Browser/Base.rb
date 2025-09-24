# Browser/Base.rb
# Browser::Base

require_relative './Bookmarks'
require_relative './History'

class Browser
  class Base
    attr_accessor\
      :bookmarks_location,
      :history_location,
      :profile_name

    def bookmarks
      Browser::Bookmarks.new(self)
    end

    def history
      Browser::History.new(self)
    end

    private

    def initialize(bookmarks_location: nil, history_location: nil, profile_name: nil)
      @bookmarks_location = bookmarks_location || self.class.bookmarks_location(profile_name: profile_name)
      @history_location = history_location || self.class.history_location(profile_name: profile_name)
      @profile_name = profile_name || self.class::DEFAULT_PROFILE_NAME
    end

    def name
      self.class.to_s.split('::').last
    end
  end
end
