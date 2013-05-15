
#
# testing rufus-decision
#
# Mon Sep  7 13:42:09 JST 2009
#

require File.expand_path('../base.rb', __FILE__)


class Dt3Test < Test::Unit::TestCase
  include DecisionTestMixin

  CSV14 = %{
in:fstate,out:result
apple,1
orange,2
}

  def test_bounded_match

    dt = Rufus::DecisionTable.new(CSV14)

    assert_equal(
      { 'fstate' => 'greenapples' },
      dt.transform({ 'fstate' => 'greenapples' }))
  end

  def test_unbounded_match

    dt = Rufus::DecisionTable.new(CSV14, :unbounded => true)

    assert_equal(
      { 'fstate' => 'apples', 'result' => '1' },
      dt.transform({ 'fstate' => 'apples' }))
  end

  CSV14b = %{
unbounded,
in:fstate,out:result
apple,1
orange,2
}

  def test_unbounded_match_set_in_table

    dt = Rufus::DecisionTable.new(CSV14b)

    assert_equal(
      { 'fstate' => 'apples', 'result' => '1' },
      dt.transform({ 'fstate' => 'apples' }))
  end
end

