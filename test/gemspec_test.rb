# gemspec_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'browser'

describe 'browser.rb.gemspec' do
  let(:spec){Gem::Specification.load(File.expand_path('../browser.rb.gemspec', __dir__))}

  it "is a valid specification" do
    expect(spec.validate).to be(true)
  end

  it "does not pin a date" do
    expect(spec.date).to eq(Gem::Specification.new.date)
  end

  it "takes its version from Browser::VERSION" do
    expect(spec.version.to_s).to eq(Browser::VERSION)
  end

  it "declares its runtime dependencies" do
    expect(spec.runtime_dependencies.map(&:name).sort).to eq(%w{CFPropertyList csv json sqlite3})
  end

  it "declares its development dependencies" do
    expect(spec.development_dependencies.map(&:name).sort).to eq(%w{minitest minitest-spec-context rake rspec-expectations})
  end

  it "ships the files a consumer reads, and no file which is not there" do
    expect(spec.files).to include('README.md', 'CHANGELOG', 'LICENSE')
    expect(spec.files.reject{|file| File.exist?(File.expand_path("../#{file}", __dir__))}).to eq([])
  end
end
