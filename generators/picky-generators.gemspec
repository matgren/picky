require File.expand_path '../../version', __FILE__

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  
  s.name = 'picky-generators'
  s.version = Picky::VERSION
  s.author = 'Florian Hanke'
  s.email = 'florian.hanke+picky-generators@gmail.com'
  s.homepage = 'http://floere.github.com/picky'
  s.rubyforge_project = 'http://rubyforge.org/projects/picky'
  
  s.description = 'Generators for Picky.'
  s.summary = 'Generators for Picky the Ruby Search Engine.'
  
  s.executables = ['picky-generator']
  s.default_executable = "picky-generator"
  
  s.files = Dir["lib/**/*.rb"]
  
  s.test_files = Dir["spec/**/*_spec.rb"]
  s.add_development_dependency 'rspec'
end