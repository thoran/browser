# Firefox_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'fileutils'
require 'tmpdir'

require 'browser'

describe Browser::Firefox do
  let(:places_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/FirefoxBased_places.sqlite")}
  let(:expected_bookmarks_sql){'SELECT moz_bookmarks.id, moz_bookmarks.parent, moz_bookmarks.position, moz_bookmarks.type, moz_bookmarks.title, moz_bookmarks.guid, moz_places.url FROM moz_bookmarks LEFT JOIN moz_places ON moz_bookmarks.fk = moz_places.id ORDER BY moz_bookmarks.parent, moz_bookmarks.position;'}
  let(:expected_history_sql){'SELECT moz_historyvisits.id, moz_places.url, moz_places.title, moz_historyvisits.visit_date FROM moz_historyvisits LEFT JOIN moz_places ON moz_historyvisits.place_id = moz_places.id ORDER BY moz_historyvisits.visit_date DESC;'}

  describe '.default_profile_name' do
    let(:profiles_ini) do
      <<~INI
        [General]
        StartWithLastProfile=0
        Version=2

        [Profile0]
        Name=default-release
        IsRelative=1
        Path=Profiles/abcd1234.default-release

        [InstallD7847D39F15872CF]
        Default=Profiles/abcd1234.default-release
        Locked=1

        [Profile1]
        Name=default
        IsRelative=1
        Path=Profiles/efgh5678.default
        Default=1
      INI
    end

    it "is the profile an [Install] section names, over the one flagged Default=1" do
      expect(Browser::Firefox.default_profile_name(profiles_ini)).to eq('abcd1234.default-release')
    end

    it "is the profile flagged Default=1 when no [Install] section names one" do
      without_install = profiles_ini.sub(/\[Install.*?\n\n/m, '')
      expect(Browser::Firefox.default_profile_name(without_install)).to eq('efgh5678.default')
    end

    it "is the only profile when nothing names a default" do
      sole = "[Profile0]\nName=default-release\nIsRelative=1\nPath=Profiles/abcd1234.default-release\n"
      expect(Browser::Firefox.default_profile_name(sole)).to eq('abcd1234.default-release')
    end

    it "raises Browser::Unreadable when two installations each name a default" do
      two = profiles_ini + "\n[Install0123456789ABCDEF]\nDefault=Profiles/efgh5678.default\n"
      expect{Browser::Firefox.default_profile_name(two)}.to raise_error(Browser::Unreadable, /names 2 profiles/)
    end

    it "raises Browser::Unreadable when there are no profiles" do
      expect{Browser::Firefox.default_profile_name("[General]\nVersion=2\n")}.to raise_error(Browser::Unreadable, /names 0 profiles/)
    end
  end

  let(:profile_name){'abcd1234.default-release'}

  context "class methods" do
    subject{Browser::Firefox}

    describe '.bookmarks_location' do
      let(:expected_bookmarks_location){File.expand_path('~/Library/Application Support/Firefox/Profiles/abcd1234.default-release/places.sqlite')}

      it "contains the correct bookmarks location" do
        expect(subject.bookmarks_location(profile_name: profile_name)).to eq(expected_bookmarks_location)
      end
    end

    describe '.history_location' do
      let(:expected_history_location){File.expand_path('~/Library/Application Support/Firefox/Profiles/abcd1234.default-release/places.sqlite')}

      it "contains the correct history location" do
        expect(subject.history_location(profile_name: profile_name)).to eq(expected_history_location)
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
    subject{Browser::Firefox.new(bookmarks_location: places_fixtures_location, history_location: places_fixtures_location, profile_name: profile_name)}

    let(:browser_name){'Firefox'}
    let(:expected_history) do
      [
        {'id' => 1, 'url' => 'https://addons.mozilla.org/en-US/firefox/', 'title' => 'Extension Starter Pack', 'visit_date' => 1787449152741667},
      ]
    end

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
        expect(subject.instance_variable_get(:@profile_name)).to eq(profile_name)
      end
    end

    describe "#name" do
      it "returns name" do
        expect(subject.send(:name)).to eq(browser_name)
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
      subject{Browser::Firefox.new(bookmarks_location: '/nonexistent/file', history_location: '/nonexistent/file')}

      it "is not readable" do
        expect(subject.bookmarks.readable?).to be(false)
        expect(subject.history.readable?).to be(false)
      end

      it "raises Browser::Unreadable" do
        expect{subject.bookmarks.to_json}.to raise_error(Browser::Unreadable)
        expect{subject.history.to_json}.to raise_error(Browser::Unreadable)
      end
    end

    context "WHEN the database is locked, as it is while the browser runs" do
      it "is not readable" do
        Dir.mktmpdir do |directory|
          path = File.join(directory, 'places.sqlite')
          FileUtils.cp(places_fixtures_location, path)
          locker = SQLite3::Database.new(path)
          locker.execute('BEGIN EXCLUSIVE')
          browser = Browser::Firefox.new(bookmarks_location: path, history_location: path)
          expect(browser.bookmarks.readable?).to be(false)
          expect{browser.history.to_json}.to raise_error(Browser::Unreadable)
          locker.close
        end
      end
    end
  end
end
