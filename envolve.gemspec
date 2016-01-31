# DO NOT EDIT - This file is automatically generated
# Make changes to Manifest.txt and/or Rakefile and regenerate
# -*- encoding: utf-8 -*-
# stub: envolve 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "envolve"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jeremy Hinegardner"]
  s.date = "2016-01-31"
  s.description = "Envolve provides a consistent and validating way to access your application configuration that is set via environment variables. This is double beneficial if you are configuring your entire application with environment variables. See. http://12factor.net/config"
  s.email = "jeremy@copiousfreetime.org"
  s.extra_rdoc_files = ["CONTRIBUTING.md", "HISTORY.md", "Manifest.txt", "README.md"]
  s.files = ["CONTRIBUTING.md", "HISTORY.md", "LICENSE", "Manifest.txt", "README.md", "Rakefile", "lib/envolve.rb", "lib/envolve/config.rb", "lib/envolve/error.rb", "lib/envolve/version.rb", "tasks/default.rake", "tasks/this.rb", "test/test_config.rb", "test/test_filtered_config.rb", "test/test_helper.rb", "test/test_key_separator_config.rb", "test/test_meta_config.rb", "test/test_prefix_config.rb", "test/test_property_config.rb", "test/test_version.rb"]
  s.homepage = "http://github.com/copiousfreetime/envolve"
  s.licenses = ["ISC"]
  s.rdoc_options = ["--main", "README.md", "--markup", "tomdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "Envolve provides a consistent and validating way to access your application configuration that is set via environment variables."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.4"])
      s.add_development_dependency(%q<minitest>, ["~> 5.4"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.9"])
    else
      s.add_dependency(%q<rake>, ["~> 10.4"])
      s.add_dependency(%q<minitest>, ["~> 5.4"])
      s.add_dependency(%q<rdoc>, ["~> 4.2"])
      s.add_dependency(%q<simplecov>, ["~> 0.9"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.4"])
    s.add_dependency(%q<minitest>, ["~> 5.4"])
    s.add_dependency(%q<rdoc>, ["~> 4.2"])
    s.add_dependency(%q<simplecov>, ["~> 0.9"])
  end
end
