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
    def should_match?(a,b)
      if a =~ /^short:/
        if a =~ /:maybe:/
          nil
        else
          true
        end
      else
        false
      end
    end

    def matches?(cell, value)
      cell.gsub(/^short:(maybe:)?/, '') == value
    end
  end

  class RaisingShortCircuit < ShortCircuit
    def matches?(cell, value)
      raise "No!"
    end
  end


  class RaisingMatcher < Rufus::Decision::Matcher
    def matches?(cell, value)
      raise "No!"
    end
  end

  def test_default_no_short_circuit
    empty_matcher1 = Matcher1.new
    assert ! empty_matcher1.should_match?(Object.new, Object.new)
    empty_matcher2 = Matcher2.new
    assert ! empty_matcher2.should_match?(Object.new, Object.new)

    table = Rufus::Decision::Table.new(%Q{
      in:first_col,out:second_col
      anything, works
    })

    table.matchers = [empty_matcher1, empty_matcher2]
    
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
    assert_nothing_raised{ table.transform wi }

    do_test(table, wi, { }, false)

    wi = { 'first_col' => 'aaa' }
    assert_nothing_raised{ table.transform wi }

    do_test(table, wi, {'second_col' => 'works' }, false)

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
    assert_raise(RuntimeError){ table.transform wi }


    wi = { 'first_col' => 'aaa' }
    assert_nothing_raised{ table.transform wi }

    do_test(table, wi, {'second_col' => 'works' }, false)
  end

end

