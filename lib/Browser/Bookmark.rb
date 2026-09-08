# Browser/Bookmark.rb
# Browser::Bookmark

# It knows nothing of how a browser stores bookmarks, only the shape they share
# once read.  The title is what the browser shows; the name is what it stores,
# which is the title but for Firefox's roots, where menu is shown as Bookmarks
# Menu, and which writing back into a browser would need.

class Browser
  class Bookmark
    attr_accessor :title, :name, :url, :children

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

    def initialize(title: nil, name: title, url: nil, children: [])
      @title = title
      @name = name
      @url = url
      @children = children
    end
  end
end
