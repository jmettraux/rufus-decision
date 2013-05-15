require File.join(File.dirname(__FILE__), 'base.rb')

require 'rufus/decision/matchers/numeric'


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
    }.each_line do |line|
      next unless line.strip!.length > 0
      cell, value = line.split(/ *\| */)
      cell.strip!
      value.strip!
      assert m.matches?(cell, value.strip), "'#{cell}' should match '#{value}'"
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
    }.each_line do |line|
      next unless line.strip!.length > 0
      cell, value = line.split(/ *\| */)
      cell.strip!
      value.strip!
      assert ! m.matches?(cell, value.strip), "'#{cell}' should NOT match '#{value}'"
    end
  end
end


