# frozen_string_literal: true

require 'yaml'

Gem::Specification.new do |gem|
  gemspec = YAML.load_file('gemspec.yml')

  gem.name    = gemspec.fetch('name')
  gem.version = gemspec.fetch('version') do
                  lib_dir = File.join(File.dirname(__FILE__),'lib')
                  $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

                  require 'ronin/db/version'
                  Ronin::DB::VERSION
                end

  gem.summary     = gemspec['summary']
  gem.description = gemspec['description']
  gem.licenses    = Array(gemspec['license'])
  gem.authors     = Array(gemspec['authors'])
  gem.email       = gemspec['email']
  gem.homepage    = gemspec['homepage']
  gem.metadata    = gemspec['metadata'] if gemspec['metadata']

  glob = ->(patterns) { gem.files & Dir[*patterns] }

  gem.files  = `git ls-files`.split($/)
  gem.files  = glob[gemspec['files']] if gemspec['files']
  gem.files += Array(gemspec['generated_files'])
  # exclude test files from the packages gem
  gem.files -= glob[gemspec['test_files'] || 'spec/{**/}*']

  gem.executables = gemspec.fetch('executables') do
    glob['bin/*'].map { |path| File.basename(path) }
  end

  gem.extensions       = glob[gemspec['extensions'] || 'ext/**/extconf.rb']
  gem.extra_rdoc_files = glob[gemspec['extra_doc_files'] || '*.{txt,md}']

  gem.require_paths = Array(gemspec.fetch('require_paths') {
    %w[ext lib].select { |dir| File.directory?(dir) }
  })

  gem.requirements              = gemspec['requirements']
  gem.required_ruby_version     = gemspec['required_ruby_version']
  gem.required_rubygems_version = gemspec['required_rubygems_version']
  gem.post_install_message      = gemspec['post_install_message']

  split = ->(string) { string.split(/,\s*/) }

  if gemspec['dependencies']
    gemspec['dependencies'].each do |name,versions|
      gem.add_dependency(name,split[versions])
    end
  end

  if gemspec['development_dependencies']
    gemspec['development_dependencies'].each do |name,versions|
      gem.add_development_dependency(name,split[versions])
    end
  end
end
