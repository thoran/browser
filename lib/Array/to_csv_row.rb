require 'String/wrap'

class Array
  # Every field quoted, and a quote within a field doubled, which is how RFC 4180
  # says a quote is carried.  Quoting everything means a comma or a newline within a
  # field needs nothing further.
  def to_csv_row
    self.collect{|e| e.to_s.gsub('"', '""').wrap('"')}.join(',')
  end
end
