
Gem::Specification.new do |s|

  s.name = 'rufus-decision'

  s.version = File.read(
    File.expand_path('../lib/rufus/decision/version.rb', __FILE__)
  ).match(/ VERSION *= *['"]([^'"]+)/)[1]

  s.platform = Gem::Platform::RUBY
  s.authors = [ 'John Mettraux' ]
  s.email = [ 'jmettraux@gmail.com' ]
  s.homepage = 'https://github.com/jmettraux/rufus-decision'
  s.rubyforge_project = 'rufus'
  s.summary = 'a decision table gem, based on CSV'

  s.description = %{
CSV based Ruby decision tables
  }.strip

  #s.files = `git ls-files`.split("\n")
  s.files = Dir[
    'Rakefile',
    'lib/**/*.rb', 'spec/**/*.rb', 'test/**/*.rb',
    '*.gemspec', '*.txt', '*.rdoc', '*.md'
  ]

  s.add_development_dependency 'rake'

  s.add_dependency 'rufus-dollar'
  s.add_dependency 'rufus-treechecker'

  s.require_path = 'lib'
end

