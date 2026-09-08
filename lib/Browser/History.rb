# Browser/History.rb
# Browser::History

require 'sqlite3'

require_relative './Rendering'
require_relative './Unreadable'

class Browser
  class History
    include Rendering

    def to_objects
      rows.collect{|row| column_names.zip(row).to_h}
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

    def column_names
      results.first
    end

    def rows
      results.drop(1)
    end
  end
end
