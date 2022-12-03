# Browser_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Browser'

describe Browser do

  describe Browser::LIST do
    it "contains the expected list of browsers" do
      expect(Browser::LIST).to eq(%w{
        Brave
        Chrome
        Chromium
        Firefox
        Safari
        TorBrowser
      })
    end
  end

  context Browser::Brave do
    describe Browser::Brave::BOOKMARKS_LOCATION do
      it "contains the correct bookmarks location" do
        expect(Browser::Brave::BOOKMARKS_LOCATION).to eq('~/Library/Application Support/BraveSoftware/Brave-Browser/Default/Bookmarks')
      end
    end

    describe Browser::Brave::HISTORY_LOCATION do
      it "contains the correct history location" do
        expect(Browser::Brave::HISTORY_LOCATION).to eq('~/Library/Application Support/BraveSoftware/Brave-Browser/Default/History')
      end
    end

    describe ".bookmarks_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Brave.bookmarks_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Brave.bookmarks_path).to eq(Pathname.new(Browser::Brave::BOOKMARKS_LOCATION))
      end
    end

    describe ".history_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Brave.history_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Brave.history_path).to eq(Pathname.new(Browser::Brave::HISTORY_LOCATION))
      end
    end
  end

  context Browser::Chrome do
    describe Browser::Chrome::BOOKMARKS_LOCATION do
      it "contains the correct bookmarks location" do
        expect(Browser::Chrome::BOOKMARKS_LOCATION).to eq('~/Library/Application Support/Google/Chrome/Default/Bookmarks')
      end
    end

    describe Browser::Chrome::HISTORY_LOCATION do
      it "contains the correct history location" do
        expect(Browser::Chrome::HISTORY_LOCATION).to eq('~/Library/Application Support/Google/Chrome/Default/History')
      end
    end

    describe ".bookmarks_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Chrome.bookmarks_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Chrome.bookmarks_path).to eq(Pathname.new(Browser::Chrome::BOOKMARKS_LOCATION))
      end
    end

    describe ".history_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Chrome.history_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Chrome.history_path).to eq(Pathname.new(Browser::Chrome::HISTORY_LOCATION))
      end
    end
  end

  context Browser::Chromium do
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

    describe ".bookmarks_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Chromium.bookmarks_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Chromium.bookmarks_path).to eq(Pathname.new(Browser::Chromium::BOOKMARKS_LOCATION))
      end
    end

    describe ".history_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Chromium.history_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Chromium.history_path).to eq(Pathname.new(Browser::Chromium::HISTORY_LOCATION))
      end
    end
  end

  context Browser::Firefox do
    describe Browser::Firefox::BOOKMARKS_LOCATION do
      it "contains the correct bookmarks location" do
        expect(Browser::Firefox::BOOKMARKS_LOCATION).to eq('~/Library/Application Support/Firefox/Profiles/**/places.sqlite')
      end
    end

    describe Browser::Firefox::HISTORY_LOCATION do
      it "contains the correct history location" do
        expect(Browser::Firefox::HISTORY_LOCATION).to eq('~/Library/Application Support/Firefox/Profiles/**/places.sqlite')
      end
    end

    describe ".bookmarks_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Firefox.bookmarks_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Firefox.bookmarks_path).to eq(Pathname.new(Browser::Firefox::BOOKMARKS_LOCATION))
      end
    end

    describe ".history_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Firefox.history_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Firefox.history_path).to eq(Pathname.new(Browser::Firefox::HISTORY_LOCATION))
      end
    end
  end

  context Browser::Safari do
    describe Browser::Safari::BOOKMARKS_LOCATION do
      it "contains the correct bookmarks location" do
        expect(Browser::Safari::BOOKMARKS_LOCATION).to eq('~/Library/Safari/Bookmarks.plist')
      end
    end

    describe Browser::Safari::HISTORY_LOCATION do
      it "contains the correct history location" do
        expect(Browser::Safari::HISTORY_LOCATION).to eq('~/Library/Safari/History.db')
      end
    end

    describe ".bookmarks_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Safari.bookmarks_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Safari.bookmarks_path).to eq(Pathname.new(Browser::Safari::BOOKMARKS_LOCATION))
      end
    end

    describe ".history_path" do
      it "returns an instance of Pathname" do
        expect(Browser::Safari.history_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::Safari.history_path).to eq(Pathname.new(Browser::Safari::HISTORY_LOCATION))
      end
    end
  end

  context Browser::TorBrowser do
    describe Browser::TorBrowser::BOOKMARKS_LOCATION do
      it "contains the correct bookmarks location" do
        expect(Browser::TorBrowser::BOOKMARKS_LOCATION).to eq('~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite')
      end
    end

    describe Browser::TorBrowser::HISTORY_LOCATION do
      it "contains the correct history location" do
        expect(Browser::TorBrowser::HISTORY_LOCATION).to eq('~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite')
      end
    end

    describe ".bookmarks_path" do
      it "returns an instance of Pathname" do
        expect(Browser::TorBrowser.bookmarks_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::TorBrowser.bookmarks_path).to eq(Pathname.new(Browser::TorBrowser::BOOKMARKS_LOCATION))
      end
    end

    describe ".history_path" do
      it "returns an instance of Pathname" do
        expect(Browser::TorBrowser.history_path).to be_a(Pathname)
      end

      it "returns the correct path" do
        expect(Browser::TorBrowser.history_path).to eq(Pathname.new(Browser::TorBrowser::HISTORY_LOCATION))
      end
    end
  end
end
