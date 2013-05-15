
require File.expand_path('../base.rb', __FILE__)


class NumericMatcherTest < Test::Unit::TestCase

  def test_substitution_true

    m = Rufus::Decision::Matchers::Numeric.new
    assert m.cell_substitution?
  end

  def test_does_match

    m = Rufus::Decision::Matchers::Numeric.new
    %Q{
      >0      |  1
      <2      |  1
      >=4.2   |  4.2
      >=4.2   |  4.201
    }.strip.each_line do |line|
      cell, value = line.split('|').collect(&:strip)
      assert m.matches?(cell, value), "'#{cell}' should match '#{value}'"
    end
  end

  def test_doesnt_match

    m = Rufus::Decision::Matchers::Numeric.new
    %Q{
      7       |  7
      7       |  8
      bob     |  bob
      1..3    | 1..3
      1..3    | 1
      >0      | -1
      <2      | 2
      >=4.2   | 4.1
      >=4.2   | 4.101
    }.strip.each_line do |line|
      cell, value = line.split('|').collect(&:strip)
      assert ! m.matches?(cell, value), "'#{cell}' should NOT match '#{value}'"
    end
  end
end


