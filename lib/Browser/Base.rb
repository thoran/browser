require_relative './History'

class Browser
  class Base
    class << self
      def bookmarks(bookmarks_location = nil)
        raise 'No concrete implementation for .bookmarks.'
      end

      def bookmarks_json(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil
      end

      def bookmarks_location
        raise 'No concrete implementation for .bookmarks_location.'
      end

      def bookmarks_plist(bookmarks_location = nil)
        bookmarks_location = bookmarks_location || self.bookmarks_location
        nil
      end

      def bookmarks_sql
        nil
      end

      def history_location
        raise 'No concrete implementation for .history_location.'
      end

      def history_sql
        raise 'No concrete implementation for .history_sql.'
      end

      def history(history_location = nil)
        Browser::History.new(self.new(history_location: history_location))
      end
    end # class << self

    attr_accessor\
      :bookmarks_location,
      :history_location

    def initialize(bookmarks_location: nil, history_location: nil)
      @bookmarks_location = bookmarks_location || self.class.bookmarks_location
      @history_location = history_location || self.class.history_location
    end

    def name
      self.class.to_s.split(':').last
    end

    def history_sql
      self.class.history_sql
    end
  end
end
