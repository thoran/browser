require_relative './lib/Browser/VERSION'

Gem::Specification.new do |spec|
  spec.name = 'browser'

  spec.version = Browser::VERSION
  spec.date = '2025-09-27'

  spec.summary = "Read and write web browser generated files with Ruby."
  spec.description = "Read and write web browser generated files with Ruby."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/browser.rb'
  spec.license = 'Ruby'

  spec.required_ruby_version = '>= 2.7'

  spec.files = [
    'CHANGELOG.txt',
    'Gemfile',
    'README.md',
    'browser.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb']
  ].flatten
  spec.require_paths = ['lib']

  spec.add_dependency('plist')
  spec.add_dependency('json')

  spec.add_development_dependency('minitest')
  spec.add_development_dependency('minitest-spec-context')
  spec.add_development_dependency('rspec-expectations')
end
