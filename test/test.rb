
#
# testing rufus-decision
#
# 2007 something
#

$:.unshift(File.dirname(File.dirname(__FILE__)))


Dir["#{File.dirname(__FILE__)}/dt_*.rb"].each { |path| load(path) }
Dir["#{File.dirname(__FILE__)}/*_test.rb"].each { |path| load(path) }

