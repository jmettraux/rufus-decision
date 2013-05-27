
require File.expand_path('../base.rb', __FILE__)


class ShortCircuitMatcherTest < Test::Unit::TestCase
  include DecisionTestMixin

  class Matcher1 < Rufus::Decision::Matcher

    def matches?(cell, value)
      value.include?("aaa")
    end
  end

  class Matcher2 < Rufus::Decision::Matcher

    def matches?(cell, value)
      value.include?("aa")
    end
  end

  class ShortCircuit < Rufus::Decision::Matcher

    def matches?(cell, value)

      m = cell.match(/^short:(maybe:)?(.*)$/)

      return false unless m    # no match

      match = (m[2] == value)

      return true if match     # match
      return false if m[1]     # no match

      :break                   # no match, but break
    end
  end

  class RaisingMatcher < Rufus::Decision::Matcher

    def matches?(cell, value)
      raise "No!"
    end
  end

  def test_default_no_short_circuit

    empty_matcher1 = Matcher1.new
    empty_matcher2 = Matcher2.new

    table = Rufus::Decision::Table.new(%Q{
      in:first_col,out:second_col
      anything, works
    })

    table.matchers = [ empty_matcher1, empty_matcher2 ]

    wi = { 'first_col' => 'aa' }
    do_test(table, wi, { "second_col" => "works" }, false)
  end

  def test_short_circuit

    table = Rufus::Decision::Table.new(%Q{
      in:first_col,out:second_col
      short:aaa, works
    })

    table.matchers = [
      ShortCircuit.new,
      RaisingMatcher.new
    ]

    wi = { 'first_col' => 'aa' }
    assert_nothing_raised { table.transform wi }

    do_test(table, wi, {}, false)

    wi = { 'first_col' => 'aaa' }
    assert_nothing_raised { table.transform wi }

    do_test(table, wi, { 'second_col' => 'works' }, false)
  end

  def test_short_circuit_maybe

    table = Rufus::Decision::Table.new(%Q{
      in:first_col,out:second_col
      short:maybe:aaa, works
    })

    table.matchers = [
      ShortCircuit.new,
      RaisingMatcher.new
    ]

    wi = { 'first_col' => 'aa' }
    assert_raise(RuntimeError) { table.transform wi }

    wi = { 'first_col' => 'aaa' }
    assert_nothing_raised { table.transform wi }

    do_test(table, wi, { 'second_col' => 'works' }, false)
  end
end

