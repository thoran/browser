require 'Array/to_csv_row'
require 'date'
require 'sqlite3'
require 'String/pascalcase'
require 'String/wrap'

class Browser
  class History

    def initialize(browser_instance)
      @browser_instance = browser_instance
    end

    def to_csv
      csv = ''
      csv << csv_header_row
      csv << csv_data_rows
      csv << "\n"
    end

    def dump
      csv_file << to_csv
      csv_file.close
    end

    private

    def database
      @database ||= SQLite3::Database.new(@browser_instance.history_location)
    end

    def results
      @results ||= (
        column_names, *rows = database.execute2(@browser_instance.history_sql)
        [column_names, rows]
      )
    end

    def column_names
      results.first
    end

    def data_rows
      results.last
    end

    def csv_header_row
      column_names.to_csv_row + "\n"
    end

    def csv_data_rows
      data_rows.collect{|row| row.to_csv_row}.join("\n")
    end

    def csv_filename
      "#{@browser_instance.name.pascalcase}History_#{Date.today}.csv"
    end

    def csv_file
      @csv_file ||= File.open(csv_filename, 'w')
    end

  end
end
