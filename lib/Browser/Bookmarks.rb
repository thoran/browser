# Browser/Bookmarks.rb
# Browser::Bookmarks

require 'json'
require 'cfpropertylist'
require 'sqlite3'

require_relative './Bookmark'
require_relative './Rendering'
require_relative './Unreadable'

class Browser
  class Bookmarks
    include Rendering

    class << self

      def from_json(browser_instance)
        data = ::JSON.parse(File.read(browser_instance.bookmarks_location))
        roots = data.fetch('roots', {}).values.select{|value| value.is_a?(Hash)}
        Browser::Bookmark.new(children: roots.collect{|root| json_node(root)})
      end

      def from_plist(browser_instance)
        data = CFPropertyList.native_types(CFPropertyList::List.new(file: browser_instance.bookmarks_location).value)
        Browser::Bookmark.new(children: plist_children(data))
      end

      def from_sqlite(browser_instance)
        database = SQLite3::Database.new(browser_instance.bookmarks_location)
        _column_names, *rows = database.execute2(browser_instance.class.send(:bookmarks_sql))
        # The query fetches leaves; folder structure is not yet reconstructed, so
        # they hang directly from the root.
        leaves = rows.collect{|_id, url, title, *| Browser::Bookmark.new(title: title, url: url)}
        Browser::Bookmark.new(children: leaves)
      end

      private

      def json_node(node)
        if node['url']
          Browser::Bookmark.new(title: node['name'], url: node['url'])
        else
          Browser::Bookmark.new(title: node['name'], children: Array(node['children']).collect{|child| json_node(child)})
        end
      end

      def plist_children(node)
        Array(node['Children']).filter_map{|child| plist_node(child)}
      end

      def plist_node(node)
        case node['WebBookmarkType']
        when 'WebBookmarkTypeLeaf'
          Browser::Bookmark.new(title: node.dig('URIDictionary', 'title'), url: node['URLString'])
        when 'WebBookmarkTypeList'
          Browser::Bookmark.new(title: node['Title'], children: plist_children(node))
        end
      end
    end

    def to_objects
      results.flatten
    end

    private

    def initialize(browser_instance)
      @browser_instance = browser_instance
    end

    def results
      @results ||= self.class.public_send("from_#{@browser_instance.class.send(:bookmarks_format)}", @browser_instance)
    rescue IOError, SystemCallError, SQLite3::Exception => e
      raise Browser::Unreadable, "#{@browser_instance.bookmarks_location} is not readable: #{e.message}"
    end

    def column_names
      %i{title url folder}
    end
  end
end
