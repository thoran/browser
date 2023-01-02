require 'String/ascii_only'
require 'String/wrap'

class Array
  def to_csv_row
    self.collect{|e| e.to_s.ascii_only.wrap('"')}.join(',')
  end
end
