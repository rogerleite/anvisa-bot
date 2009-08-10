# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{anvisa-bot}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roger Leite"]
  s.date = %q{2009-08-10}
  s.default_executable = %q{anvisa-bot}
  s.email = %q{roger.barreto@gmail.com}
  s.executables = ["anvisa-bot"]
  s.files = ["lib/anvisa_bot.rb", "lib/anvisa_parser.rb", "lib/anvisa_browser.rb", "Rakefile", "README.textile", "bin", "lib", "pkg", "spec", "nbproject", "fluxo_site_anvisa.txt", "anvisa-bot.gemspec", "bin/anvisa-bot"]
  s.homepage = %q{http://github.com/rogerleite/anvisa-bot}
  s.require_paths = ["bin", "lib"]
  s.rubyforge_project = %q{anvisa-bot}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Pesquisa de produtos para saúde registrados}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.8.1"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.8.1"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.8.1"])
  end
end
