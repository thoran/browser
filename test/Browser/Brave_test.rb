# Brave_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'browser'

describe Browser::Brave do
  let(:bookmarks_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/Brave_bookmarks.json")}
  let(:history_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/ChromiumBased_history.sqlite")}
  let(:expected_history_sql){'SELECT * FROM urls ORDER BY last_visit_time DESC;'}

  describe Browser::Brave::DEFAULT_PROFILE_NAME do
    let(:expected_default_profile_name){'Default'}

    it "contains the correct default profile name" do
      expect(Browser::Brave::DEFAULT_PROFILE_NAME).to eq(expected_default_profile_name)
    end
  end

  context "class methods" do
    subject{Browser::Brave}

    describe '.bookmarks_location' do
      let(:expected_bookmarks_location){File.expand_path('~/Library/Application Support/BraveSoftware/Brave-Browser/Default/Bookmarks')}

      it "contains the correct bookmarks location" do
        expect(subject.bookmarks_location).to eq(expected_bookmarks_location)
      end
    end

    describe '.history_location' do
      let(:expected_history_location){File.expand_path('~/Library/Application Support/BraveSoftware/Brave-Browser/Default/History')}

      it "contains the correct history location" do
        expect(subject.history_location).to eq(expected_history_location)
      end
    end

    describe '.profile_path' do
      let(:expected_profile_path){File.expand_path('~/Library/Application Support/BraveSoftware/Brave-Browser/Default')}

      it "contains the correct profile path" do
        expect(subject.profile_path).to eq(expected_profile_path)
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
    subject{Browser::Brave.new(bookmarks_location: bookmarks_fixtures_location, history_location: history_fixtures_location)}

    let(:browser_name){'Brave'}
    let(:default_profile_name){'Default'}
    let(:expected_history) do
      [
        {url: 'https://www.chromium.org/chromium-projects/', title: 'Home', visited_at: Time.utc(2025, 9, 25)},
        {url: 'chrome://welcome/', title: 'Welcome', visited_at: Time.utc(2025, 9, 24, 23, 43, 20)},
      ]
    end

    describe "#initialize" do
      it "returns an instance of Browser" do
        expect(subject).to be_a(Browser::Brave)
      end

      it "assigns @bookmarks_location" do
        expect(subject.instance_variable_get(:@bookmarks_location)).to eq(bookmarks_fixtures_location)
      end

      it "assigns @history_location" do
        expect(subject.instance_variable_get(:@history_location)).to eq(history_fixtures_location)
      end

      it "takes the default profile name when none is given" do
        expect(subject.profile_name).to eq(default_profile_name)
      end
    end

    describe "#name" do
      it "returns name" do
        expect(subject.name).to eq(browser_name)
      end
    end

    describe "#profile_path" do
      it "returns the directory the profile sits in" do
        expect(subject.profile_path).to eq(File.expand_path('~/Library/Application Support/BraveSoftware/Brave-Browser/Default'))
      end
    end

    let(:expected_bookmarks) do
      [
        {title: 'Welcome to Brave', url: 'chrome://welcome/', folder: 'Bookmarks bar'},
      ]
    end

    describe "#bookmarks" do
      it "returns an instance of Browser::Bookmarks" do
        expect(subject.bookmarks).to be_a(Browser::Bookmarks)
      end

      it "returns the bookmarks" do
        expect(subject.bookmarks.to_objects).to eq(expected_bookmarks)
      end
    end

    describe "#history" do
      it "returns an instance of Browser::History" do
        expect(subject.history).to be_a(Browser::History)
      end

      it "returns the history" do
        expect(subject.history.to_objects).to eq(expected_history)
      end
    end

    describe "#readable?" do
      it "is true when the data is there" do
        expect(subject.bookmarks.readable?).to be(true)
        expect(subject.history.readable?).to be(true)
      end
    end

    context "WHEN the data is not there" do
      subject{Browser::Brave.new(bookmarks_location: '/nonexistent/file', history_location: '/nonexistent/file')}

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
