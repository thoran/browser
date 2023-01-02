# Browser_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Browser'

describe Browser::Chromium do
  let(:bookmarks_location){File.expand_path("#{__FILE__}/../../fixtures/Chromium_bookmarks.json")}

  describe Browser::Chromium::BOOKMARKS_LOCATION do
    it "contains the correct bookmarks location" do
      expect(Browser::Chromium::BOOKMARKS_LOCATION).to eq('~/Library/Application Support/Chromium/Default/Bookmarks')
    end
  end

  describe Browser::Chromium::HISTORY_LOCATION do
    it "contains the correct history location" do
      expect(Browser::Chromium::HISTORY_LOCATION).to eq('~/Library/Application Support/Chromium/Default/History')
    end
  end

  describe ".bookmarks" do
    let(:expected_bookmarks_json){JSON.parse(File.read(bookmarks_location))}

    it "returns an instance of Hash" do
      expect(Browser::Chromium.bookmarks(bookmarks_location)).to be_a(Hash)
    end

    it "returns the bookmarks" do
      expect(Browser::Chromium.bookmarks(bookmarks_location)).to eq(expected_bookmarks_json)
    end
  end

  describe ".bookmarks_json" do
    let(:expected_bookmarks_json){JSON.parse(File.read(bookmarks_location))}

    it "returns an instance of Hash" do
      expect(Browser::Chromium.bookmarks_json(bookmarks_location)).to be_a(Hash)
    end

    it "returns the bookmarks" do
      expect(Browser::Chromium.bookmarks_json(bookmarks_location)).to eq(expected_bookmarks_json)
    end
  end

  describe ".bookmarks_location" do
    context "WITHOUT arguments" do
      it "returns an instance of String" do
        expect(Browser::Chromium.bookmarks_location).to be_a(String)
      end

      it "returns the correct path" do
        expect(Browser::Chromium.bookmarks_location).to eq(File.expand_path(Browser::Chromium::BOOKMARKS_LOCATION))
      end
    end

    context "WITH arguments" do
      it "returns an instance of String" do
        expect(Browser::Chromium.bookmarks_location(bookmarks_location)).to be_a(String)
      end

      it "returns the correct path" do
        expect(Browser::Chromium.bookmarks_location(bookmarks_location)).to eq(bookmarks_location)
      end
    end
  end

  describe ".bookmarks_plist" do
    it "is nil" do
      expect(Browser::Chromium.bookmarks_plist).to be_nil
    end
  end

  describe ".history_location" do
    it "returns an instance of String" do
      expect(Browser::Chromium.history_location).to be_a(String)
    end

    it "returns the correct path" do
      expect(Browser::Chromium.history_location).to eq(File.expand_path(Browser::Chromium::HISTORY_LOCATION))
    end
  end

  describe ".history_sql" do
    it "returns an instance of String" do
      expect(Browser::Chromium.history_sql).to be_a(String)
    end
  end

  describe "#initialize" do
    it "returns an instance of Browser" do
      expect(Browser.new('Brave')).to be_a(Browser)
    end

    it "assigns @name" do
      expect(Browser.new('Brave').instance_variable_get(:@name)).to eq('Brave')
    end

    it "assigns @bookmarks_location" do
      expect(Browser.new('Brave', bookmarks_location: bookmarks_location).instance_variable_get(:@bookmarks_location)).to eq(bookmarks_location)
    end
  end

  describe "#name" do
    it "returns name" do
      expect(Browser.new('Brave').name).to eq('Brave')
    end
  end

  describe "#bookmarks" do
    let(:expected_bookmarks){JSON.parse(File.read(bookmarks_location))}

    it "returns a hash" do
      expect(Browser.new('Brave', bookmarks_location: bookmarks_location).bookmarks).to be_a(Hash)
    end

    it "returns the bookmarks" do
      expect(Browser.new('Brave', bookmarks_location: bookmarks_location).bookmarks).to eq(expected_bookmarks)
    end
  end

  describe "#bookmarks_json" do
    let(:expected_bookmarks_json){JSON.parse(File.read(bookmarks_location))}

    it "returns a hash" do
      expect(Browser.new('Brave', bookmarks_location: bookmarks_location).bookmarks_json).to be_a(Hash)
    end

    it "returns the bookmarks" do
      expect(Browser.new('Brave', bookmarks_location: bookmarks_location).bookmarks_json).to eq(expected_bookmarks_json)
    end
  end

  describe "#bookmarks_plist" do
    it "returns the bookmarks plist" do
      expect(Browser.new('Brave').bookmarks_plist).to be_nil
    end
  end

  describe "#bookmarks_sql" do
    it "returns the bookmarks sql" do
      expect(Browser.new('Brave').bookmarks_sql).to be_nil
    end
  end

  describe "#history_sql" do
    it "returns the history sql" do
      expect(Browser.new('Brave').history_sql).to eq('SELECT * FROM urls ORDER BY last_visit_time DESC;')
    end
  end
end
