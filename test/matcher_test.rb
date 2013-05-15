require File.join(File.dirname(__FILE__), 'base.rb')


class MatcherTest < Test::Unit::TestCase
  def test_base_class    
    empty_matcher = Rufus::Decision::Matcher.new
    refute empty_matcher.matches?(Object.new, Object.new)
    assert empty_matcher.cell_substitution?
  end
end

