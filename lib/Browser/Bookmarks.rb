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
        column_names, *rows = database.execute2(browser_instance.class.send(:bookmarks_sql))
        records = rows.collect{|row| column_names.zip(row).to_h}
        children = records.group_by{|record| record['parent']}
        Browser::Bookmark.new(children: Array(children[0]).flat_map{|root| sqlite_children(root, children)})
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

      # moz_bookmarks is one table of folders and bookmarks, each row naming its
      # parent and its position within it, and the root the row with no parent.
      # The tags root is left out: a tag is a folder holding a copy of every
      # bookmark so tagged, and Firefox does not show it as one.
      def sqlite_children(record, children)
        Array(children[record['id']]).filter_map{|child| sqlite_node(child, children)}
      end

      # type 1 is a bookmark, 2 a folder and 3 a separator.
      def sqlite_node(record, children)
        case record['type']
        when 1
          Browser::Bookmark.new(title: record['title'], url: record['url'])
        when 2
          sqlite_folder(record, children) unless record['guid'] == 'tags________'
        end
      end

      # The roots are stored under names Firefox never shows; these are the names it does.
      SQLITE_ROOT_TITLES = {
        'menu________' => 'Bookmarks Menu',
        'toolbar_____' => 'Bookmarks Toolbar',
        'unfiled_____' => 'Other Bookmarks',
        'mobile______' => 'Mobile Bookmarks',
      }

      def sqlite_folder(record, children)
        title = SQLITE_ROOT_TITLES.fetch(record['guid'], record['title'])
        Browser::Bookmark.new(title: title, name: record['title'], children: sqlite_children(record, children))
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

    # The tree as the browser keeps it: a titleless root whose children are the
    # browser's own roots.  to_objects flattens it and keeps only the leaves, so the
    # folders, and Bookmark#name with them, are reachable nowhere else.
    def tree
      results
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
