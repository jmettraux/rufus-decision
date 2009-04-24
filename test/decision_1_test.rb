
#
# Testing rufus-deciision
#
# Sun Oct 29 15:41:44 JST 2006
#

require 'test/unit'

require File.dirname(__FILE__) + '/test_base.rb'


class Decision1Test < Test::Unit::TestCase
  include DecisionTestMixin

  CSV1 = %{
,,
in:fx,in:fy,out:fz
,,
a,${fx},0
c,d,${fx}
e,f,${r:3+4}
g,h,${r:'${fx}' + '${fy}'}
}

  def test_1

    wi = { 'fx' => 'c', 'fy' => 'd' }
    do_test(CSV1, wi, {}, { 'fz' => 'c' }, false)

    wi = { 'fx' => 'a', 'fy' => 'a' }
    do_test(CSV1, wi, {}, { 'fz' => '0' }, false)
  end

  def test_1b

    h = { 'fx' => 'e', 'fy' => 'f' }
    do_test(CSV1, h, { :ruby_eval => true }, { "fz" => "7" }, false)
  end

  def test_1c

    h = { 'fx' => 'g', 'fy' => 'h' }
    do_test(CSV1, h, { :ruby_eval => true }, { "fz" => "gh" }, false)
  end

  CSV2 = [
    %w{ in:fx in:fy out:fz },
    %w{ a ${fx} 0 },
    %w{ c d ${fx} },
    %w{ e f ${r:3+4} },
    [ 'g', 'h', "${r:'${fx}' + '${fy}'}" ]
  ]

  def test_with_array_table

    wi = { 'fx' => 'c', 'fy' => 'd' }
    do_test(CSV2, wi, {}, { 'fz' => 'c' }, false)
  end

  def test_empty_string_to_float

    wi = { 'age' => '', 'trait' => 'maniac', 'name' => 'Baumgarter' }

    table = [
      %w{ in:age in:trait out:salesperson },
      [ '18..35', '', 'Adeslky' ],
      [ '25..35', '', 'Bronco' ],
      [ '36..50', '', 'Espradas' ],
      [ '', 'maniac', 'Korolev' ]
    ]

    do_test(table, wi, {}, { 'salesperson' => 'Korolev' }, false)
  end

  def test_vertical_rules

    table = CSV2.transpose

    wi = { 'fx' => 'c', 'fy' => 'd' }
    do_test(table, wi, {}, { 'fz' => 'c' }, false)
  end

end

