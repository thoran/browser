# Browser/History.rb
# Browser::History

require 'date'
require 'json'
require 'cfpropertylist'
require 'sqlite3'

require 'Array/to_csv_row'

require_relative './Unreadable'

class Browser
  class History
    class CSV
      def render
        csv = ''
        csv << csv_header_row
        csv << csv_data_rows
        csv << "\n"
      end

      private

      def initialize(results)
        @results = results
      end

      def column_names
        @results.first
      end

      def data_rows
        @results.last
      end

      def csv_header_row
        column_names.to_csv_row + "\n"
      end

      def csv_data_rows
        data_rows.collect{|row| row.to_csv_row}.join("\n")
      end
    end

    class JSON
      def render
        Objects.new(@results).render.to_json
      end

      private

      def initialize(results)
        @results = results
      end
    end

    class Plist
      def render
        list = CFPropertyList::List.new
        list.value = CFPropertyList.guess(Objects.new(@results).render)
        list.to_str(CFPropertyList::List::FORMAT_XML)
      end

      private

      def initialize(results)
        @results = results
      end
    end

    class Objects
      def render
        rows_to_h
      end

      private

      def initialize(results)
        @results = results
      end

      def column_names
        @results.first
      end

      def data_rows
        @results.last
      end

      def rows_to_h
        data_rows.collect do |row|
          column_names.zip(row).to_h
        end
      end
    end

    def to_csv
      CSV.new(results).render
    end

    def to_json
      JSON.new(results).render
    end

    def to_plist
      Plist.new(results).render
    end

    def to_objects
      Objects.new(results).render
    end

    def dump(format: :csv, filename: nil, path: '.')
      full_path = (
        if filename
          filename.include?(File::SEPARATOR) ? filename : File.join(path, filename)
        else
          File.join(path, dump_filename(format))
        end
      )
      File.write(full_path, public_send("to_#{format}"))
      full_path
    rescue Errno::ENOENT => e
      raise "Cannot write to #{full_path}: #{e.message}"
    end

    def readable?
      results
      true
    rescue Browser::Unreadable
      false
    end

    private

    def initialize(browser_instance)
      @browser_instance = browser_instance
    end

    def database
      @database ||= SQLite3::Database.new(@browser_instance.history_location)
    end

    def results
      @results ||= (
        column_names, *rows = database.execute2(@browser_instance.class.send(:history_sql))
        [column_names, rows]
      )
    rescue IOError, SystemCallError, SQLite3::Exception => e
      raise Browser::Unreadable, "#{@browser_instance.history_location} is not readable: #{e.message}"
    end

    def dump_filename(extension)
      if @browser_instance.profile_name
        "#{@browser_instance.send(:name)}_#{@browser_instance.profile_name}_History_#{Date.today}.#{extension}"
      else
        "#{@browser_instance.send(:name)}_History_#{Date.today}.#{extension}"
      end
    end
  end
end
