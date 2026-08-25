# Browser/Bookmark.rb
# Browser::Bookmark

# A bookmark, which may hold bookmarks: a folder is a Bookmark with children, a
# leaf is a Bookmark with a url, and the root is the Bookmark the whole tree hangs
# from.  It knows nothing of how a browser stores bookmarks, only the shape they
# share once read.

class Browser
  class Bookmark
    attr_accessor :title, :url, :children

    def leaf?
      !@url.nil?
    end

    def folder?
      !leaf?
    end

    # The root's own title is not a folder anyone filed under, so a titleless or
    # rootless node adds nothing to the path.
    def flatten(path = [])
      if leaf?
        [{title: @title, url: @url, folder: path.join('/')}]
      else
        here = @title.to_s.empty? ? path : path + [@title]
        @children.flat_map{|child| child.flatten(here)}
      end
    end

    private

    def initialize(title: nil, url: nil, children: [])
      @title = title
      @url = url
      @children = children
    end
  end
end
