# TorBrowser_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Browser'

describe Browser::TorBrowser do
  let(:bookmarks_fixtures_location){File.expand_path("#{__FILE__}/../fixtures/Chromium_bookmarks.json")}
  let(:history_fixtures_location){'/path/to/history'}
  let(:history_sql){'SELECT * FROM moz_historyvisits ORDER BY ? DESC;'}

  describe Browser::Safari.bookmarks_location do
    let(:expected_bookmarks_location){'~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite'}

    it "contains the correct bookmarks location" do
      expect(Browser::Safari.bookmarks_location).to eq(expected_bookmarks_location)
    end
  end

  describe Browser::Safari.history_location do
    let(:expected_bookmarks_location){'~/Library/Application Support/TorBrowser-Data/Profiles/**/places.sqlite'}

    it "contains the correct history location" do
      expect(Browser::Safari.history_location).to eq(expected_history_location)
    end
  end

  describe Browser::TorBrowser::DEFAULT_PROFILE_NAME do
    let(:expected_default_profile_name){'**'}

    it "contains the correct history location" do
      expect(Browser::TorBrowser::DEFAULT_PROFILE_NAME).to eq(expected_default_profile_name)
    end
  end

  context "class methods" do
    subject{Browser::TorBrowser}

    describe ".bookmarks" do
      it "returns nil for now" do
        expect(subject.bookmarks).to be_nil
      end
    end

    describe ".bookmarks_json" do
      it "returns nil" do
        expect(subject.bookmarks_json(bookmarks_fixtures_location)).to be_nil
      end
    end

    describe ".bookmarks_location" do
      context "WITHOUT arguments" do
        let(:expected_bookmarks_location) do
          File.expand_path(File.join(subject::PROFILE_ROOT_PATH, subject::DEFAULT_PROFILE_NAME, 'places.sqlite'))
        end

        it "returns an instance of String" do
          expect(subject.bookmarks_location).to be_a(String)
        end

        it "returns the correct path" do
          expect(subject.bookmarks_location).to eq(expected_bookmarks_location)
        end
      end

      context "WITH arguments" do
        it "returns an instance of String" do
          expect(subject.bookmarks_location(bookmarks_location: bookmarks_fixtures_location)).to be_a(String)
        end

        it "returns the correct path" do
          expect(subject.bookmarks_location(bookmarks_location: bookmarks_fixtures_location)).to eq(bookmarks_fixtures_location)
        end
      end
    end

    describe ".bookmarks_plist" do
      it "is nil" do
        expect(subject.bookmarks_plist).to be_nil
      end
    end

    describe ".bookmarks_sql" do
      it "returns an instance of String" do
        expect(subject.bookmarks_sql).to be_a(String)
      end

      it "returns the bookmarks sql" do
        expect(subject.bookmarks_sql).to eq('SELECT * FROM moz_bookmarks ORDER BY ? DESC;')
      end
    end

    describe ".history_location" do
      context "WITHOUT arguments" do
        let(:expected_history_location) do
          File.expand_path(File.join(subject::PROFILE_ROOT_PATH, subject::DEFAULT_PROFILE_NAME, 'places.sqlite'))
        end

        it "returns an instance of String" do
          expect(subject.history_location).to be_a(String)
        end

        it "returns the correct path" do
          expect(subject.history_location).to eq(expected_history_location)
        end
      end

      context "WITH arguments" do
        it "returns an instance of String" do
          expect(subject.history_location(history_location: history_fixtures_location)).to be_a(String)
        end

        it "returns the correct path" do
          expect(subject.history_location(history_location: history_fixtures_location)).to eq(history_fixtures_location)
        end
      end
    end

    describe ".history_sql" do
      it "returns an instance of String" do
        expect(subject.history_sql).to be_a(String)
      end

      it "returns the history sql" do
        expect(subject.history_sql).to eq('SELECT * FROM moz_historyvisits ORDER BY ? DESC;')
      end
    end
  end

  context "instance methods" do
    subject{Browser.new(browser_name, bookmarks_location: bookmarks_fixtures_location, history_location: history_fixtures_location)}

    let(:browser_name){'TorBrowser'}

    describe "#initialize" do
      it "returns an instance of Browser" do
        expect(subject).to be_a(Browser)
      end

      it "assigns @name" do
        expect(subject.instance_variable_get(:@name)).to eq(browser_name)
      end

      it "assigns @bookmarks_location" do
        expect(subject.instance_variable_get(:@bookmarks_location)).to eq(bookmarks_fixtures_location)
      end

      it "assigns @history_location" do
        expect(subject.instance_variable_get(:@history_location)).to eq(history_fixtures_location)
      end
    end

    describe "#name" do
      it "returns name" do
        expect(subject.name).to eq(browser_name)
      end
    end

    describe "#bookmarks" do
      it "returns nil" do
        expect(subject.bookmarks).to be_nil
      end
    end

    describe "#bookmarks_json" do
      it "returns nil" do
        expect(subject.bookmarks_json).to be_nil
      end
    end

    describe "#bookmarks_plist" do
      it "returns nil" do
        expect(subject.bookmarks_plist).to be_nil
      end
    end

    describe "#bookmarks_sql" do
      it "returns the bookmarks sql" do
        expect(subject.bookmarks_sql).to eq('SELECT * FROM moz_bookmarks ORDER BY ? DESC;')
      end
    end

    describe "#history_sql" do
      it "returns the history sql" do
        expect(subject.history_sql).to eq('SELECT * FROM moz_historyvisits ORDER BY ? DESC;')
      end
    end
  end
end
