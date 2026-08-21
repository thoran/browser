# Firefox_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Browser'

describe Browser::Firefox do
  let(:places_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/FirefoxBased_places.sqlite")}
  let(:expected_bookmarks_sql){'SELECT * FROM moz_bookmarks ORDER BY ? DESC;'}
  let(:expected_history_sql){'SELECT * FROM moz_historyvisits ORDER BY ? DESC;'}

  describe Browser::Firefox::DEFAULT_PROFILE_NAME do
    let(:expected_default_profile_name){'**'}

    it "contains the correct default profile name" do
      expect(Browser::Firefox::DEFAULT_PROFILE_NAME).to eq(expected_default_profile_name)
    end
  end

  context "class methods" do
    subject{Browser::Firefox}

    describe '.bookmarks_location' do
      let(:expected_bookmarks_location){File.expand_path('~/Library/Application Support/Firefox/Profiles/**/places.sqlite')}

      it "contains the correct bookmarks location" do
        expect(subject.bookmarks_location).to eq(expected_bookmarks_location)
      end
    end

    describe '.history_location' do
      let(:expected_history_location){File.expand_path('~/Library/Application Support/Firefox/Profiles/**/places.sqlite')}

      it "contains the correct history location" do
        expect(subject.history_location).to eq(expected_history_location)
      end
    end

    describe ".bookmarks_sql" do
      it "returns the bookmarks sql" do
        expect(subject.send(:bookmarks_sql)).to eq(expected_bookmarks_sql)
      end
    end

    describe ".history_sql" do
      it "returns the history sql" do
        expect(subject.send(:history_sql)).to eq(expected_history_sql)
      end
    end
  end

  context "instance methods" do
    subject{Browser::Firefox.new(bookmarks_location: places_fixtures_location, history_location: places_fixtures_location)}

    let(:browser_name){'Firefox'}
    let(:default_profile_name){'**'}

    describe "#initialize" do
      it "returns an instance of Browser" do
        expect(subject).to be_a(Browser::Firefox)
      end

      it "assigns @bookmarks_location" do
        expect(subject.instance_variable_get(:@bookmarks_location)).to eq(places_fixtures_location)
      end

      it "assigns @history_location" do
        expect(subject.instance_variable_get(:@history_location)).to eq(places_fixtures_location)
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
    end

    describe "#history" do
      it "returns an instance of Browser::History" do
        expect(subject.history).to be_a(Browser::History)
      end
    end
  end
end
