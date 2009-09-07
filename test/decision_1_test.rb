
#
# Testing rufus-deciision
#
# Sun Oct 29 15:41:44 JST 2006
#

require 'test/unit'

require File.join(File.dirname(__FILE__), 'test_base.rb')


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
    do_test(CSV1, wi, { 'fz' => 'c' }, false)

    wi = { 'fx' => 'a', 'fy' => 'a' }
    do_test(CSV1, wi, { 'fz' => '0' }, false)
  end

  def test_1b

    table = Rufus::Decision::Table.new(CSV1, :ruby_eval => true)

    h = { 'fx' => 'e', 'fy' => 'f' }
    do_test(table, h, { 'fz' => '7' }, false)
  end

  def test_1c

    table = Rufus::Decision::Table.new(CSV1, :ruby_eval => true)

    h = { 'fx' => 'g', 'fy' => 'h' }
    do_test(table, h, { 'fz' => 'gh' }, false)
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
    do_test(CSV2, wi, { 'fz' => 'c' }, false)
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

    do_test(table, wi, { 'salesperson' => 'Korolev' }, false)
  end

  def test_vertical_rules

    table = CSV2.transpose

    wi = { 'fx' => 'c', 'fy' => 'd' }
    do_test(table, wi, { 'fz' => 'c' }, false)
  end

  def test_vertical_rules_2

    table = %{
in:topic,sports,sports,finance,finance,finance,politics,politics,politics,
in:region,europe,,america,europe,,asia,america,,
out:team_member,Alice,Bob,Charly,Donald,Ernest,Fujio,Gilbert,Henry,Zach
    }

    h = { 'topic' => 'politics', 'region' => 'america' }
    do_test(table, h, { 'team_member' => 'Gilbert' }, false)
  end

end

