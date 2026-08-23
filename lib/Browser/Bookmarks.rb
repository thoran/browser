# Browser/Bookmarks.rb
# Browser::Bookmarks

require 'date'
require 'json'
require 'cfpropertylist'
require 'sqlite3'

require 'Array/to_csv_row'

class Browser
  class Bookmarks
    class CSV
      def render
        csv = "title,url,folder\n"
        @results.each do |bookmark|
          csv << "#{bookmark[:title]},#{bookmark[:url]},#{bookmark[:folder]}\n"
        end
        csv
      end

      private

      def initialize(results)
        @results = results
      end
    end

    class JSON
      def render
        @results.to_json
      end

      private

      def initialize(results)
        @results = results
      end
    end

    class Plist
      def render
        list = CFPropertyList::List.new
        list.value = CFPropertyList.guess(@results)
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

    class << self
      def from_json(browser_instance)
        ::JSON.parse(File.read(browser_instance.bookmarks_location))
      end

      def from_plist(browser_instance)
        CFPropertyList.native_types(CFPropertyList::List.new(file: browser_instance.bookmarks_location).value)
      end

      def from_sqlite(browser_instance)
        database = SQLite3::Database.new(browser_instance.bookmarks_location)
        column_names, *rows = database.execute2(browser_instance.class.send(:bookmarks_sql))
        [column_names, rows]
      end
    end

    def to_csv
      CSV.new(to_objects).render
    end

    def to_json
      JSON.new(to_objects).render
    end

    def to_plist
      Plist.new(to_objects).render
    end

    def to_objects
      case @browser_instance.class.send(:bookmarks_format)
      when :json; results
      when :plist; results
      when :sqlite; Objects.new(results).render
      end
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

    private

    def initialize(browser_instance)
      @browser_instance = browser_instance
    end

    def results
      @results ||= self.class.public_send("from_#{@browser_instance.class.send(:bookmarks_format)}", @browser_instance)
    end

    def dump_filename(extension)
      if @browser_instance.profile_name
        "#{@browser_instance.send(:name)}_#{@browser_instance.profile_name}_Bookmarks_#{Date.today}.#{extension}"
      else
        "#{@browser_instance.send(:name)}_Bookmarks_#{Date.today}.#{extension}"
      end
    end
  end
end
