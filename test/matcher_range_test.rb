
require File.expand_path('../base.rb', __FILE__)


class RangeMatcherTest < Test::Unit::TestCase

  def test_substitution_true

    m = Rufus::Decision::Matchers::Range.new
    assert m.cell_substitution?
  end

  def test_does_match

    m = Rufus::Decision::Matchers::Range.new
    %Q{
      1..4    |  2
      3..10   |  10
      3...10  |  9
    }.strip.each_line do |line|
      cell, value = line.split('|').collect(&:strip)
      assert m.matches?(cell, value), "'#{cell}' should match '#{value}'"
    end
  end

  def test_doesnt_match

    m = Rufus::Decision::Matchers::Range.new
    %Q{
      foo     |  bar
      1..3    | 0
      >0      | 1
      <2      | 2
      <=2     | 1
      >=4.2   | 4.3
      1..4    |  5
      3..10   |  11
      3...10  |  10
    }.strip.each_line do |line|
      cell, value = line.split('|').collect(&:strip)
      assert ! m.matches?(cell, value), "'#{cell}' should NOT match '#{value}'"
    end
  end
end


