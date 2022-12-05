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

  Browser::LIST.each do |browser|
    browser_test_filename = File.expand_path("#{__FILE__}/../#{browser}_test")
    require browser_test_filename
  end
end
