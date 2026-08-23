# Browser/Unreadable.rb
# Browser::Unreadable

# Raised when a browser's data cannot be read: the file is not there, the browser
# has it locked, or the format library cannot open it.  The underlying exception is
# available as #cause, which Ruby sets when this is raised from a rescue.

class Browser
  class Unreadable < StandardError
  end
end
