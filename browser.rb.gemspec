require_relative './lib/Browser/VERSION'

Gem::Specification.new do |spec|
  spec.name = 'browser.rb'

  spec.version = Browser::VERSION

  spec.summary = "Read and write web browser generated files with Ruby."
  spec.description = "Read and write web browser generated files with Ruby."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/browser.rb'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.7'

  spec.files = [
    Dir['lib/**/*.rb'],
    Dir['test/**/*'],
    'browser.rb.gemspec',
    'CHANGELOG',
    'Gemfile',
    'LICENSE',
    'Rakefile',
    'README.md',
  ].flatten
  spec.require_paths = ['lib']

  spec.add_dependency('CFPropertyList')
  spec.add_dependency('json')
  spec.add_dependency('sqlite3')

  spec.add_development_dependency('minitest')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('minitest-spec-context')
  spec.add_development_dependency('rspec-expectations')
end
