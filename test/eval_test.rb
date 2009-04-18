
#
# Testing rufus-decision
#
# John Mettraux at openwfe.org
#
# Mon Oct  9 22:19:44 JST 2006
#

require 'test/unit'

require File.dirname(__FILE__) + '/test_base.rb'

require 'rufus/hashes'

#
# testing the 'dollar notation'
#

class EvalTest < Test::Unit::TestCase

  #def setup
  #end

  #def teardown
  #end

  def test_0

    eh = Rufus::EvalHashFilter.new({})

    eh['a'] = :a
    eh['b'] = 'r:5 * 5'

    assert_equal :a, eh['a']
    assert_equal 25, eh['b']
    assert_equal 72, eh['r:36+36']
  end
end
