$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'podling/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'podling'
  spec.version     = Podling::VERSION
  spec.authors     = ['Matt Powell']
  spec.email       = ['fauxparse@gmail.com']
  spec.homepage    = 'https://github.com/fauxparse/podling'
  spec.summary     = 'Rails engine for simple podcast hosting.'
  spec.description = 'Rails engine for simple podcast hosting.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'TODO: Set to http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.test_files = Dir['spec/**/*']

  spec.add_dependency 'rails', '~> 5.2.2'

  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rspec-rails', '~> 3.8.2'
  spec.add_development_dependency 'rubocop', '~> 0.64.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 4.0.0.rc1'
end
