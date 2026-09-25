# loading_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

# Each of these wants a process of its own, with nothing on the load path but lib and no
# RUBYLIB, which is what a consumer of the gem has: within this one everything is loaded
# already, so nothing here could tell a require which works from one which was never run.

describe 'loading' do
  def ruby(source, *flags)
    lib = File.expand_path('../lib', __dir__)
    IO.popen({'RUBYLIB' => nil}, ['ruby', *flags, "-I#{lib}", '-e', source], err: [:child, :out]){|io| io.read}.strip
  end

  it "defines Browser::VERSION on require 'browser'" do
    expect(ruby('require "browser"; print Browser::VERSION')).to match(/\A\d+\.\d+\.\d+\z/)
  end

  it "resolves every helper it requires from lib alone" do
    expect(ruby('require "browser"; print $LOADED_FEATURES.grep(/String\/wrap/).size')).to eq('1')
  end

  it "gives the top-level names on require 'browser-classes'" do
    expect(ruby('require "browser-classes"; print Chrome.equal?(Browser::Chrome)')).to eq('true')
  end

  it "loads without warning under -w" do
    expect(ruby('require "browser"; require "browser-classes"; print "ok"', '-w')).to eq('ok')
  end
end
