# Bookmark_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'browser'

describe Browser::Bookmark do
  describe "#leaf? and #folder?" do
    it "a bookmark with a url is a leaf" do
      bookmark = Browser::Bookmark.new(title: 'Home', url: 'https://example.com/')
      expect(bookmark.leaf?).to be(true)
      expect(bookmark.folder?).to be(false)
    end

    it "a bookmark without a url is a folder" do
      folder = Browser::Bookmark.new(title: 'Bar', children: [])
      expect(folder.folder?).to be(true)
      expect(folder.leaf?).to be(false)
    end
  end

  describe "#name" do
    it "is the title unless given, which is what a browser stores where that differs from what it shows" do
      expect(Browser::Bookmark.new(title: 'Bookmarks Menu').name).to eq('Bookmarks Menu')
      expect(Browser::Bookmark.new(title: 'Bookmarks Menu', name: 'menu').name).to eq('menu')
    end
  end

  describe "#flatten" do
    subject do
      Browser::Bookmark.new(children: [
        Browser::Bookmark.new(title: 'Bar', children: [
          Browser::Bookmark.new(title: 'Home', url: 'https://example.com/'),
          Browser::Bookmark.new(title: 'Work', children: [
            Browser::Bookmark.new(title: 'Mail', url: 'https://mail.example.com/'),
          ]),
        ]),
        Browser::Bookmark.new(title: 'Top', url: 'https://top.example.com/'),
        Browser::Bookmark.new(title: 'Empty', children: []),
      ])
    end

    it "returns a record per leaf, and none for folders" do
      expect(subject.flatten.length).to eq(3)
    end

    it "carries the folder path each leaf sits under, nesting joined by /" do
      expect(subject.flatten).to eq([
        {title: 'Home', url: 'https://example.com/', folder: 'Bar'},
        {title: 'Mail', url: 'https://mail.example.com/', folder: 'Bar/Work'},
        {title: 'Top', url: 'https://top.example.com/', folder: ''},
      ])
    end

    it "the rootless, titleless node adds nothing to the path" do
      expect(subject.flatten.first[:folder]).to eq('Bar')
    end

    it "an empty folder contributes no records" do
      empty = Browser::Bookmark.new(title: 'Empty', children: [])
      expect(empty.flatten).to eq([])
    end
  end
end
