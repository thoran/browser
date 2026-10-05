# Safari_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'browser'

describe Browser::Safari do
  let(:bookmarks_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/Safari_bookmarks.plist")}
  let(:history_fixtures_location){File.expand_path("#{__FILE__}/../../fixtures/Safari_history.sqlite")}
  let(:expected_history_sql){'SELECT history_visits.id, history_items.url, history_visits.title, history_visits.visit_time, history_visits.load_successful, history_visits.http_non_get, history_visits.synthesized, history_visits.redirect_source, history_visits.redirect_destination, history_visits.origin, history_items.visit_count, history_items.status_code FROM history_visits LEFT JOIN history_items ON history_visits.history_item = history_items.id ORDER BY history_visits.visit_time DESC;'}

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

    describe '.profile_path' do
      it "has no profile path, Safari having no profiles" do
        expect(subject.profile_path).to be_nil
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
    let(:expected_history) do
      [
        {url: 'https://www.apple.com/', title: 'Apple', visited_at: Time.utc(2025, 9, 25)},
        {url: 'https://support.apple.com/', title: 'Apple Support', visited_at: Time.utc(2025, 9, 24, 23, 40)},
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
        expect(subject.name).to eq(browser_name)
      end
    end

    describe "#profile_path" do
      it "has no profile path, Safari having no profiles" do
        expect(subject.profile_path).to be_nil
      end
    end

    let(:expected_bookmarks) do
      [
        {title: 'Apple', url: 'https://www.apple.com/', folder: 'BookmarksBar'},
        {title: 'iCloud', url: 'https://www.icloud.com/', folder: 'BookmarksBar'},
        {title: 'Yahoo', url: 'https://www.yahoo.com/', folder: 'BookmarksBar'},
        {title: 'Bing', url: 'https://www.bing.com/', folder: 'BookmarksBar'},
        {title: 'Google', url: 'https://www.google.com/?client=safari&channel=mac_bm', folder: 'BookmarksBar'},
        {title: 'Wikipedia', url: 'https://www.wikipedia.org/', folder: 'BookmarksBar'},
        {title: 'Facebook', url: 'https://www.facebook.com/', folder: 'BookmarksBar'},
        {title: 'Twitter', url: 'https://twitter.com/', folder: 'BookmarksBar'},
        {title: 'LinkedIn', url: 'https://www.linkedin.com/', folder: 'BookmarksBar'},
        {title: 'The Weather Channel', url: 'https://www.weather.com/', folder: 'BookmarksBar'},
        {title: 'Yelp', url: 'https://www.yelp.com/', folder: 'BookmarksBar'},
        {title: 'TripAdvisor', url: 'https://www.tripadvisor.com/', folder: 'BookmarksBar'},
        {title: 'Home \ Anthropic', url: 'https://www.anthropic.com/', folder: ''},
      ]
    end

    describe "#bookmarks" do
      it "returns an instance of Browser::Bookmarks" do
        expect(subject.bookmarks).to be_a(Browser::Bookmarks)
      end

      it "returns the bookmarks" do
        expect(subject.bookmarks.to_objects).to eq(expected_bookmarks)
      end

      it "returns the tree, whose children are the browser's roots" do
        expect(subject.bookmarks.tree).to be_a(Browser::Bookmark)
        expect(subject.bookmarks.tree.children.collect(&:title)).to eq(['BookmarksBar', 'BookmarksMenu', 'Home \ Anthropic'])
      end
    end

    describe "#history" do
      it "returns an instance of Browser::History" do
        expect(subject.history).to be_a(Browser::History)
      end

      it "returns the history" do
        expect(subject.history.to_objects).to eq(expected_history)
      end

      it "returns the visits, with the title history_visits holds" do
        visit = subject.history.visits.first
        expect(visit).to be_a(Browser::Visit)
        expect(visit.title).to eq('Apple')
        expect(visit.visited_at).to eq(Time.utc(2025, 9, 25))
        expect(visit.attributes['visit_time']).to eq(780451200.0)
      end

      it "carries everything meaningful either table holds, and none of the bookkeeping" do
        attributes = subject.history.visits.first.attributes
        expect(attributes['load_successful']).to eq(1)
        expect(attributes['status_code']).to eq(200)
        expect(attributes['visit_count']).to eq(3)
        expect(attributes['origin']).to eq(0)
        expect(attributes.keys).to_not include('history_item', 'domain_expansion', 'daily_visit_counts', 'visit_count_score', 'score', 'generation', 'attributes')
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
