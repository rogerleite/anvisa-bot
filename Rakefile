require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

GEM = "anvisa-bot"
GEM_VERSION = "0.2.2"
SUMMARY = "Pesquisa de produtos para saúde registrados"
AUTHOR = "Roger Leite"
EMAIL = "roger.barreto@gmail.com"
HOMEPAGE = "http://github.com/rogerleite/anvisa-bot"


spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['bin', 'lib']
  s.files = FileList['bin/*.rb', 'lib/**/*.rb', '[A-Z]*'].to_a
  s.executables = ["anvisa-bot"]

  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.rubyforge_project = GEM # GitHub bug, gem isn't being build when this miss

  s.add_dependency(%q<hpricot>, [">= 0.8.1"])
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

