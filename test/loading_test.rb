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
end
