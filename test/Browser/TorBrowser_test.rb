# TorBrowser_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'browser'

describe Browser::TorBrowser do
  let(:places_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/FirefoxBased_places.sqlite")}
  let(:expected_bookmarks_sql){'SELECT moz_bookmarks.id, moz_bookmarks.parent, moz_bookmarks.position, moz_bookmarks.type, moz_bookmarks.title, moz_bookmarks.guid, moz_places.url FROM moz_bookmarks LEFT JOIN moz_places ON moz_bookmarks.fk = moz_places.id ORDER BY moz_bookmarks.parent, moz_bookmarks.position;'}
  let(:expected_history_sql){'SELECT moz_historyvisits.id, moz_places.url, moz_places.title, moz_historyvisits.visit_date, moz_historyvisits.from_visit, moz_historyvisits.visit_type, moz_historyvisits.session, moz_historyvisits.source, moz_places.visit_count, moz_places.hidden, moz_places.typed, moz_places.last_visit_date, moz_places.guid, moz_places.description, moz_places.preview_image_url, moz_places.site_name FROM moz_historyvisits LEFT JOIN moz_places ON moz_historyvisits.place_id = moz_places.id ORDER BY moz_historyvisits.visit_date DESC;'}

  describe '.default_profile_name' do
    let(:profiles_ini){"[Profile0]\nName=default\nIsRelative=1\nPath=abcd1234.default\nDefault=1\n\n[General]\nStartWithLastProfile=1\nVersion=2\n"}

    it "is the one profile Tor Browser flags, which sits beside profiles.ini rather than under Profiles" do
      expect(Browser::TorBrowser.default_profile_name(profiles_ini)).to eq('abcd1234.default')
    end
  end

  let(:profile_name){'abcd1234.default'}

  context "class methods" do
    subject{Browser::TorBrowser}

    describe '.bookmarks_location' do
      let(:expected_bookmarks_location){File.expand_path('~/Library/Application Support/TorBrowser-Data/Browser/abcd1234.default/places.sqlite')}

      it "contains the correct bookmarks location" do
        expect(subject.bookmarks_location(profile_name: profile_name)).to eq(expected_bookmarks_location)
      end
    end

    describe '.history_location' do
      let(:expected_history_location){File.expand_path('~/Library/Application Support/TorBrowser-Data/Browser/abcd1234.default/places.sqlite')}

      it "contains the correct history location" do
        expect(subject.history_location(profile_name: profile_name)).to eq(expected_history_location)
      end
    end

    describe '.profile_path' do
      let(:expected_profile_path){File.expand_path('~/Library/Application Support/TorBrowser-Data/Browser/abcd1234.default')}

      it "contains the correct profile path" do
        expect(subject.profile_path(profile_name: profile_name)).to eq(expected_profile_path)
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
    subject{Browser::TorBrowser.new(bookmarks_location: places_fixtures_location, history_location: places_fixtures_location, profile_name: profile_name)}

    let(:browser_name){'TorBrowser'}
    let(:expected_history) do
      [
        {url: 'https://addons.mozilla.org/en-US/firefox/', title: 'Extension Starter Pack', visited_at: Time.utc(2026, 8, 23, 1, 39, 12) + Rational(741_667, 1_000_000)},
      ]
    end

    describe "#initialize" do
      it "returns an instance of Browser" do
        expect(subject).to be_a(Browser::TorBrowser)
      end

      it "assigns @bookmarks_location" do
        expect(subject.instance_variable_get(:@bookmarks_location)).to eq(places_fixtures_location)
      end

      it "assigns @history_location" do
        expect(subject.instance_variable_get(:@history_location)).to eq(places_fixtures_location)
      end

      it "assigns @profile_name" do
        expect(subject.instance_variable_get(:@profile_name)).to eq(profile_name)
      end
    end

    describe "#name" do
      it "returns name" do
        expect(subject.name).to eq(browser_name)
      end
    end

    describe "#profile_path" do
      it "returns the directory the profile sits in" do
        expect(subject.profile_path).to eq(File.expand_path('~/Library/Application Support/TorBrowser-Data/Browser/abcd1234.default'))
      end
    end

    let(:expected_bookmarks) do
      [
        {title: 'Get Help', url: 'https://support.mozilla.org/products/firefox', folder: 'Bookmarks Menu/Mozilla Firefox'},
        {title: 'Customize Firefox', url: 'https://support.mozilla.org/kb/customize-firefox-controls-buttons-and-toolbars', folder: 'Bookmarks Menu/Mozilla Firefox'},
        {title: 'Get Involved', url: 'https://www.mozilla.org/contribute/', folder: 'Bookmarks Menu/Mozilla Firefox'},
        {title: 'About Us', url: 'https://www.mozilla.org/about/', folder: 'Bookmarks Menu/Mozilla Firefox'},
        {title: 'Extension Starter Pack', url: 'https://addons.mozilla.org/en-US/firefox/', folder: 'Bookmarks Toolbar'},
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
      subject{Browser::TorBrowser.new(bookmarks_location: '/nonexistent/file', history_location: '/nonexistent/file')}

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
