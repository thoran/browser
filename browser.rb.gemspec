# browser.rb.gemspec

require_relative './lib/Browser/VERSION'

class Gem::Specification
  def dependencies=(gems)
    gems.each{|gem| add_dependency(*gem)}
  end

  def development_dependencies=(gems)
    gems.each{|gem| add_development_dependency(*gem)}
  end
end

Gem::Specification.new do |spec|
  spec.name = 'browser.rb'
  spec.version = Browser::VERSION

  spec.summary = "Read web browser bookmarks and history with Ruby."
  spec.description = "Read the bookmarks and history of the web browsers on a machine, Brave, Chrome, Chromium, Firefox, Safari and Tor Browser, and render them to CSV, JSON or a property list.  Bookmarks come through as one representation whatever the browser; history as each browser stores it."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'https://github.com/thoran/browser'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.2'
  spec.require_paths = ['lib']

  spec.files = [
    'browser.rb.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*'],
    'CHANGELOG',
    'Gemfile',
    'LICENSE',
    'Rakefile',
    'README.md',
  ].flatten

  spec.dependencies = %w{
    CFPropertyList
    csv
    json
    sqlite3
  }

  spec.development_dependencies = %w{
    minitest
    rake
    minitest-spec-context
    rspec-expectations
  }
end
