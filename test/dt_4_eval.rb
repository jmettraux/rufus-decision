
#
# testing rufus-decision
#
# Mon Oct  9 22:19:44 JST 2006
#

require File.dirname(__FILE__) + '/test_base.rb'

require 'rufus/decision/hashes'


class Dt4Test < Test::Unit::TestCase

  def test_0

    eh = Rufus::Decision::EvalHashFilter.new({})

    eh['a'] = :a
    eh['b'] = 'r:5 * 5'

    assert_equal :a, eh['a']
    assert_equal 25, eh['b']
    assert_equal 72, eh['r:36+36']
  end
end

