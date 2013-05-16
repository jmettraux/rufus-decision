
require File.expand_path('../base.rb', __FILE__)


class StringMatcherTest < Test::Unit::TestCase

  def test_substitution_true

    m = Rufus::Decision::Matchers::String.new
    m.options = {}

    assert m.cell_substitution?
  end

  def test_does_match

    m = Rufus::Decision::Matchers::String.new
    m.options = {}

    %Q{
      a       |  a
      mary    |  mary
    }.strip.each_line do |line|
      cell, value = line.split('|').collect(&:strip)
      assert m.matches?(cell, value), "'#{cell}' should match '#{value}'"
    end
  end

  def test_doesnt_match

    m = Rufus::Decision::Matchers::String.new
    m.options = {}

    %Q{
      foo     |  bar
      1..3    | 1
      >0      | 1
      <2      | 2
      <=2     | 1
      >=4.2   | 4.3
    }.strip.each_line do |line|
      cell, value = line.split('|').collect(&:strip)
      assert ! m.matches?(cell, value), "'#{cell}' should NOT match '#{value}'"
    end
  end
end


