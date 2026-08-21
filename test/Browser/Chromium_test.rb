# Chromium_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Browser'

describe Browser::Chromium do
  let(:bookmarks_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/Chromium_bookmarks.json")}
  let(:history_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/ChromiumBased_history.sqlite")}
  let(:expected_history_sql){'SELECT * FROM urls ORDER BY last_visit_time DESC;'}

  describe Browser::Chromium::DEFAULT_PROFILE_NAME do
    let(:expected_default_profile_name){'Default'}

    it "contains the correct default profile name" do
      expect(Browser::Chromium::DEFAULT_PROFILE_NAME).to eq(expected_default_profile_name)
    end
  end

  context "class methods" do
    subject{Browser::Chromium}

    describe '.bookmarks_location' do
      let(:expected_bookmarks_location){File.expand_path('~/Library/Application Support/Chromium/Default/Bookmarks')}

      it "contains the correct bookmarks location" do
        expect(subject.bookmarks_location).to eq(expected_bookmarks_location)
      end
    end

    describe '.history_location' do
      let(:expected_history_location){File.expand_path('~/Library/Application Support/Chromium/Default/History')}

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
    subject{Browser::Chromium.new(bookmarks_location: bookmarks_fixtures_location, history_location: history_fixtures_location)}

    let(:browser_name){'Chromium'}
    let(:default_profile_name){'Default'}
    let(:expected_bookmarks){JSON.parse(File.read(bookmarks_fixtures_location))}
    let(:expected_history) do
      [
        {'id' => 1, 'url' => 'https://www.chromium.org/chromium-projects/', 'title' => 'Home', 'visit_count' => 3, 'typed_count' => 1, 'last_visit_time' => 13403232000000000, 'hidden' => 0},
        {'id' => 2, 'url' => 'chrome://welcome/', 'title' => 'Welcome', 'visit_count' => 1, 'typed_count' => 0, 'last_visit_time' => 13403231000000000, 'hidden' => 0},
      ]
    end

    describe "#initialize" do
      it "returns an instance of Browser" do
        expect(subject).to be_a(Browser::Chromium)
      end

      it "assigns @bookmarks_location" do
        expect(subject.instance_variable_get(:@bookmarks_location)).to eq(bookmarks_fixtures_location)
      end

      it "assigns @history_location" do
        expect(subject.instance_variable_get(:@history_location)).to eq(history_fixtures_location)
      end

      it "assigns @profile_name" do
        expect(subject.instance_variable_get(:@profile_name)).to eq(default_profile_name)
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
  end
end
