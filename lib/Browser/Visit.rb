# Browser/Visit.rb
# Browser::Visit

# It knows nothing of how a browser stores history, only the shape they share once
# read: a url, a title and a time.  For Firefox and Safari a row is one visit; for
# the Chromium family it is a url and the last visit to it, so a page visited three
# times is one Visit there and three elsewhere.  The browser's own row stays as
# attributes, since Chromium's visit_count, typed_count and hidden have no
# counterpart in the others, and Safari stores no title at all.

class Browser
  class Visit
    attr_accessor :url, :title, :visited_at, :attributes

    def to_h
      {url: @url, title: @title, visited_at: @visited_at}
    end

    private

    def initialize(url: nil, title: nil, visited_at: nil, attributes: {})
      @url = url
      @title = title
      @visited_at = visited_at
      @attributes = attributes
    end
  end
end
