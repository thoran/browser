# Safari_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Browser'

describe Browser::Safari do
  let(:bookmarks_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/Safari_bookmarks.plist")}
  let(:history_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/Safari_history.sqlite")}
  let(:expected_history_sql){'SELECT history_items.id, history_items.url, history_visits.visit_time FROM history_items LEFT JOIN history_visits WHERE history_items.id = history_visits.history_item ORDER BY visit_time DESC;'}

  describe 'DEFAULT_PROFILE_NAME' do
    it "has no default profile name" do
      expect(Browser::Safari::DEFAULT_PROFILE_NAME).to be_nil
    end
  end

  context "class methods" do
    subject{Browser::Safari}

    describe '.bookmarks_location' do
      let(:expected_bookmarks_location){File.expand_path('~/Library/Safari/Bookmarks.plist')}

      it "contains the correct bookmarks location" do
        expect(subject.bookmarks_location).to eq(expected_bookmarks_location)
      end
    end

    describe '.history_location' do
      let(:expected_history_location){File.expand_path('~/Library/Safari/History.db')}

      it "contains the correct history location" do
        expect(subject.history_location).to eq(expected_history_location)
      end
    end

    describe ".bookmarks_sql" do
      it "returns the bookmarks sql" do
        expect(subject.send(:bookmarks_sql)).to be_nil
      end
    end

    describe ".history_sql" do
      it "returns the history sql" do
        expect(subject.send(:history_sql)).to eq(expected_history_sql)
      end
    end
  end

  context "instance methods" do
    subject{Browser::Safari.new(bookmarks_location: bookmarks_fixtures_location, history_location: history_fixtures_location)}

    let(:browser_name){'Safari'}
    let(:expected_bookmarks){CFPropertyList.native_types(CFPropertyList::List.new(file: bookmarks_fixtures_location).value)}
    let(:expected_history) do
      [
        {'id' => 1, 'url' => 'https://www.apple.com/', 'visit_time' => 780451200.0},
        {'id' => 2, 'url' => 'https://support.apple.com/', 'visit_time' => 780450000.0},
      ]
    end

    describe "#initialize" do
      it "returns an instance of Browser" do
        expect(subject).to be_a(Browser::Safari)
      end

      it "assigns @bookmarks_location" do
        expect(subject.instance_variable_get(:@bookmarks_location)).to eq(bookmarks_fixtures_location)
      end

      it "assigns @history_location" do
        expect(subject.instance_variable_get(:@history_location)).to eq(history_fixtures_location)
      end

      it "assigns no @profile_name" do
        expect(subject.instance_variable_get(:@profile_name)).to be_nil
      end
    end

    describe "#name" do
      it "returns name" do
        expect(subject.send(:name)).to eq(browser_name)
      end
    end

    describe "#bookmarks" do
      it "returns an instance of Browser::Bookmarks" do
        expect(subject.bookmarks).to be_a(Browser::Bookmarks)
      end

      it "returns the bookmarks as JSON" do
        expect(subject.bookmarks.to_json).to eq(expected_bookmarks.to_json)
      end
    end

    describe "#history" do
      it "returns an instance of Browser::History" do
        expect(subject.history).to be_a(Browser::History)
      end

      it "returns the history" do
        expect(subject.history.to_json).to eq(expected_history.to_json)
      end
    end

    describe "#readable?" do
      it "is true when the data is there" do
        expect(subject.bookmarks.readable?).to be(true)
        expect(subject.history.readable?).to be(true)
      end
    end

    context "WHEN the data is not there" do
      subject{Browser::Safari.new(bookmarks_location: '/nonexistent/file', history_location: '/nonexistent/file')}

      it "is not readable" do
        expect(subject.bookmarks.readable?).to be(false)
        expect(subject.history.readable?).to be(false)
      end

      it "raises Browser::Unreadable" do
        expect{subject.bookmarks.to_json}.to raise_error(Browser::Unreadable)
        expect{subject.history.to_json}.to raise_error(Browser::Unreadable)
      end
    end
  end
end
