$:.unshift File.dirname(File.dirname(__FILE__))
#
# testing rufus-decision
#
# 2007 something
#

Dir["#{File.dirname(__FILE__)}/dt_*.rb"].each { |path| load(path) }

