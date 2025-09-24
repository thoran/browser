# Browser/History.rb
# Browser::History

require 'csv'
require 'date'
require 'json'
require 'plist'
require 'sqlite3'

require 'String/pascalcase'

class Browser
  class History
    module Formatter
      class CSV
        def render
          ::CSV.generate do |csv|
            csv << column_names
            data_rows.each { |row| csv << row }
          end
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
          Objects.new(@results).render.to_plist
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
    end # module Formatter

    def to_csv
      Formatter::CSV.new(results).render
    end

    def to_json
      Formatter::JSON.new(results).render
    end

    def to_plist
      Formatter::Plist.new(results).render
    end

    def to_objects
      Formatter::Objects.new(results).render
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

    def database
      @database ||= (
        location = @browser_instance.class.history_location
        raise "History database not found: #{location}" unless File.exist?(location)
        SQLite3::Database.new(location)
      )
    end

    def results
      @results ||= (
        column_names, *rows = database.execute2(@browser_instance.class.history_sql)
        [column_names, rows]
      )
    rescue SQLite3::Exception => e
      raise "Failed to query history database: #{e.message}"
    end

    def dump_filename(extension)
      if @browser_instance.profile_name
        "#{@browser_instance.name.pascalcase}_#{@browser_instance.profile_name}_History_#{Date.today}.#{extension}"
      else
        "#{@browser_instance.name.pascalcase}_History_#{Date.today}.#{extension}"
      end
    end
  end
end
