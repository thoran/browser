# Visit_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'browser'

describe Browser::Visit do
  let(:visited_at){Time.utc(2025, 9, 25)}

  describe "#to_h" do
    it "keeps the three fields every browser holds, and nothing else" do
      visit = Browser::Visit.new(
        url: 'https://example.com/',
        title: 'Home',
        visited_at: visited_at,
        attributes: {'visit_count' => 3},
      )
      expect(visit.to_h).to eq({url: 'https://example.com/', title: 'Home', visited_at: visited_at})
    end

    it "carries a nil title where the browser gave none" do
      expect(Browser::Visit.new(url: 'https://example.com/', visited_at: visited_at).to_h[:title]).to be_nil
    end
  end

  describe "#attributes" do
    it "holds the browser's own row, which to_h drops" do
      row = {'id' => 1, 'url' => 'https://example.com/', 'visit_count' => 3, 'hidden' => 0}
      expect(Browser::Visit.new(url: 'https://example.com/', attributes: row).attributes).to eq(row)
    end

    it "is empty when the browser gave none" do
      expect(Browser::Visit.new(url: 'https://example.com/').attributes).to eq({})
    end
  end
end
