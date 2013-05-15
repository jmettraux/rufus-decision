
require File.expand_path('../base.rb', __FILE__)


class StringMatcherTest < Test::Unit::TestCase

  def test_substitution_true
    m = Rufus::Decision::Matchers::String.new
    assert m.cell_substitution?
  end

  def test_does_match
    m = Rufus::Decision::Matchers::String.new
    %Q{
      a       |  a
      mary    |  mary
    }.each_line do |line|
      next unless line.strip!.length > 0
      cell, value = line.split(/ *\| */)
      cell.strip!
      value.strip!
      assert m.matches?(cell, value.strip), "'#{cell}' should match '#{value}'"
    end
  end

  def test_doesnt_match
    m = Rufus::Decision::Matchers::String.new
    %Q{
      foo     |  bar
      1..3    | 1
      >0      | 1
      <2      | 2
      <=2     | 1
      >=4.2   | 4.3
    }.each_line do |line|
      next unless line.strip!.length > 0
      cell, value = line.split(/ *\| */)
      cell.strip!
      value.strip!
      assert ! m.matches?(cell, value.strip), "'#{cell}' should NOT match '#{value}'"
    end
  end
end


