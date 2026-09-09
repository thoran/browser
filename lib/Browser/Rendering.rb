# Browser/Rendering.rb
# Browser::Rendering

# The renderers, once.  CSV, JSON and a plist, each over records and their column
# names, which is the shape Bookmarks and History both arrive at: Bookmarks by
# flattening its tree, History from its query.  Including it gives a class to_csv,
# to_json, to_plist, dump and readable?; the class supplies results, to_objects and
# column_names.

require 'date'
require 'json'
require 'cfpropertylist'

require 'Array/to_csv_row'

require_relative './Unreadable'

class Browser
  module Rendering
    class CSV
      def render
        ([@column_names] + rows).collect{|row| row.to_csv_row}.join("\n") + "\n"
      end

      private

      def initialize(records, column_names)
        @records = records
        @column_names = column_names
      end

      def rows
        @records.collect{|record| record.values_at(*@column_names)}
      end
    end

    class JSON
      def render
        @records.to_json
      end

      private

      def initialize(records)
        @records = records
      end
    end

    class Plist
      def render
        list = CFPropertyList::List.new
        list.value = CFPropertyList.guess(@records)
        list.to_str(CFPropertyList::List::FORMAT_XML)
      end

      private

      def initialize(records)
        @records = records
      end
    end

    def to_csv
      CSV.new(to_objects, column_names).render
    end

    def to_json
      JSON.new(to_objects).render
    end

    def to_plist
      Plist.new(to_objects).render
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

    def dump_filename(extension)
      [@browser_instance.name, @browser_instance.profile_name, kind, Date.today].compact.join('_') + ".#{extension}"
    end

    def kind
      self.class.name.split('::').last
    end
  end
end
