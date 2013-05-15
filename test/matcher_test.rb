
require File.expand_path('../base.rb', __FILE__)


class MatcherTest < Test::Unit::TestCase

  def test_base_class
    empty_matcher = Rufus::Decision::Matcher.new
    assert ! empty_matcher.matches?(Object.new, Object.new)
    assert empty_matcher.cell_substitution?
  end
end

