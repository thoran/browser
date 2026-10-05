# Browser/History.rb
# Browser::History

require 'sqlite3'

require_relative './Rendering'
require_relative './Unreadable'
require_relative './Visit'

class Browser
  class History
    include Rendering

    # The history as the browser keeps it, each row a Browser::Visit, which carries
    # the browser's own columns besides the three they share.  to_objects keeps only
    # those three, so the surplus is reachable nowhere else.
    def visits
      @visits ||= rows.collect{|row| visit(row)}
    end

    def to_objects
      visits.collect(&:to_h)
    end

    private

    def initialize(browser_instance)
      @browser_instance = browser_instance
    end

    def database
      @database ||= SQLite3::Database.new(@browser_instance.history_location)
    end

    def results
      @results ||= database.execute2(@browser_instance.class.send(:history_sql))
    rescue IOError, SystemCallError, SQLite3::Exception => e
      raise Browser::Unreadable, "#{@browser_instance.history_location} is not readable: #{e.message}"
    end

    def rows
      names, *values = results
      values.collect{|value| names.zip(value).to_h}
    end

    def visit(row)
      Browser::Visit.new(
        url: row['url'],
        title: row['title'],
        visited_at: @browser_instance.class.send(:visited_at, row),
        attributes: row,
      )
    end

    def column_names
      %i{url title visited_at}
    end
  end
end
