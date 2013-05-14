
$:.unshift('.') # 1.9.2

require 'rubygems'

require 'rake'
require 'rake/clean'


#
# clean

CLEAN.include('pkg')


#
# test / spec

task :test do

  exec 'bundle exec ruby test/test.rb'
end

task :default => [ :spec ]
task :spec => [ :test ]


#
# gem

GEMSPEC_FILE = Dir['*.gemspec'].first
GEMSPEC = eval(File.read(GEMSPEC_FILE))
GEMSPEC.validate


desc %{
  builds the gem and places it in pkg/
}
task :build do

  sh "gem build #{GEMSPEC_FILE}"
  sh "mkdir pkg" rescue nil
  sh "mv #{GEMSPEC.name}-#{GEMSPEC.version}.gem pkg/"
end

desc %{
  builds the gem and pushes it to rubygems.org
}
task :push => :build do

  sh "gem push pkg/#{GEMSPEC.name}-#{GEMSPEC.version}.gem"
end


##
## TO THE WEB
#
#task :upload_website => [ :clean, :yard ] do
#
#  account = 'jmettraux@rubyforge.org'
#  webdir = '/var/www/gforge-projects/rufus'
#
#  sh "rsync -azv -e ssh html/rufus-decision #{account}:#{webdir}/"
#end

