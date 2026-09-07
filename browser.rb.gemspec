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

  spec.summary = "Read and write web browser generated files with Ruby."
  spec.description = "Read and write web browser generated files with Ruby."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'https://github.com/thoran/browser'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.7'
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
