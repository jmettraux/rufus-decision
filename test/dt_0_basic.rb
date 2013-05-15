
#
# testing rufus-decision
#
# Sun Oct 29 15:41:44 JST 2006
#

require File.join(File.dirname(__FILE__), 'base.rb')


class Dt0Test < Test::Unit::TestCase
  include DecisionTestMixin

  CSV0 = %{
,,
in:fx,in:fy,out:fz
,,
a,b,0
c,d,1
e,f,2
}

  def test_0

    wi = {
      "fx" => "c",
      "fy" => "d"
    }
    do_test(CSV0, wi, { "fz" => "1" }, false)

    wi = {
      "fx" => "a",
      "fy" => "d"
    }
    do_test(CSV0, wi, { "fz" => nil }, false)
  end

  CSV0B = %{
in:fx,in:fy,out:fz

a,b,0
c,d,1
e,f,2
}

  def test_0b

    wi = {
      "fx" => "c",
      "fy" => "d"
    }
    do_test(CSV0B, wi, { "fz" => "1" }, false)
  end

  # test 1 moved to decision_1_test.rb

  CSV2 = %{
in:fx, in:fy, out:fz
,,
a,   b,   0
c,   d,   1
e,   f,   2
}

  def test_2

    wi = { "fx" => "c", "fy" => "d" }
    do_test(CSV2, wi, { "fz" => "1" }, false)

    wi = { "fx" => "a", "fy" => "d" }
    do_test(CSV2, wi, { "fz" => nil }, false)
  end

  CSV3 = %{
in:weather, in:month, out:take_umbrella?
,,
raining,  ,     yes
sunny,    ,     no
cloudy,   june,   yes
cloudy,   may,    yes
cloudy,   ,     no
}

  def test_3

    wi = {
      "weather" => "raining",
      "month" => "december"
    }
    do_test(CSV3, wi, { "take_umbrella?" => "yes" }, false)

    wi = {
      "weather" => "cloudy",
      "month" => "june"
    }
    do_test(CSV3, wi, { "take_umbrella?" => "yes" }, false)

    wi = {
      "weather" => "cloudy",
      "month" => "march"
    }
    do_test(CSV3, wi, { "take_umbrella?" => "no" }, false)
  end

  def test_3b

    h = {}
    h["weather"] = "raining"
    h["month"] = "december"
    do_test(CSV3, h, { "take_umbrella?" => "yes" }, false)

    h = {}
    h["weather"] = "cloudy"
    h["month"] = "june"
    do_test(CSV3, h, { "take_umbrella?" => "yes" }, false)

    h = {}
    h["weather"] = "cloudy"
    h["month"] = "march"
    do_test(CSV3, h, { "take_umbrella?" => "no" }, false)
  end

  def test_3c

    table = Rufus::DecisionTable.new(%{
      in:topic,in:region,out:team_member
      sports,europe,Alice
      sports,,Bob
      finance,america,Charly
      finance,europe,Donald
      finance,,Ernest
      politics,asia,Fujio
      politics,america,Gilbert
      politics,,Henry
      ,,Zach
    })

    h = {}
    h["topic"] = "politics"
    table.transform! h

    assert_equal "Henry",  h["team_member"]
  end

  def test_3e

    table = Rufus::DecisionTable.new(%{
      in:topic,in:region,out:team_member
      sports,europe,Alice
    })

    h0 = {}
    h0["topic"] = "politics"
    h1 = table.transform! h0

    assert_equal h0.object_id, h1.object_id

    h0 = {}
    h0["topic"] = "politics"
    h1 = table.transform h0

    assert_not_equal h0.object_id, h1.object_id
  end


  def test_through_and_ignorecase

    table = %{
      through,ignorecase,,
      ,,,
      in:fx, in:fy, out:fX, out:fY
      ,,,
      a,   ,    true,
      ,    a,   ,     true
      b,   ,    false,
      ,    b,   ,     false
    }

    wi = { 'fx' => 'a', 'fy' => 'a' }
    do_test(table, wi, { 'fX' => 'true', 'fY' => 'true' }, false)

    wi = { 'fx' => 'a', 'fy' => 'b' }
    do_test(table, wi, { 'fX' => 'true', 'fY' => 'false' }, false)

    wi = { 'fx' => 'A', 'fy' => 'b' }
    do_test(table, wi, { 'fX' => 'true', 'fY' => 'false' }, false)
  end

  def test_through_and_ignorecase_set_at_table_initialization

    table = %{
      in:fx, in:fy, out:fX, out:fY
      ,,,
      a,   ,    true,
      ,    a,   ,     true
      b,   ,    false,
      ,    b,   ,     false
    }

    table = Rufus::Decision::Table.new(
      table, :through => true, :ignore_case => true)

    wi = { 'fx' => 'a', 'fy' => 'a' }
    do_test(table, wi, { 'fX' => 'true', 'fY' => 'true' }, false)

    wi = { 'fx' => 'a', 'fy' => 'b' }
    do_test(table, wi, { 'fX' => 'true', 'fY' => 'false' }, false)

    wi = { 'fx' => 'A', 'fy' => 'b' }
    do_test(table, wi, { 'fX' => 'true', 'fY' => 'false' }, false)
  end

  #
  # TEST 6

  CSV6 = %{
,
in:fx, out:fy
,
<10,a
<=100,b
,c
}

  def test_6

    wi = {
      "fx" => "5"
    }
    do_test(CSV6, wi, { "fy" => "a" }, false)

    wi = {
      "fx" => "100.0001"
    }
    do_test(CSV6, wi, { "fy" => "c" }, false)
  end

  #
  # TEST 7

  CSV7 = %{
,
in:fx, out:fy
,
>100,a
>=10,b
,c
}

  def test_7

    wi = {
      "fx" => "5"
    }
    do_test(CSV7, wi, { "fy" => "c" }, false)

    wi = {
      "fx" => "10"
    }
    do_test(CSV7, wi, { "fy" => "b" }, false)

    wi = {
      "fx" => "10a"
    }
    do_test(CSV7, wi, { "fy" => "a" }, false)
  end

  CSV8 = %{
in:efx,in:efy,out:efz
a,b,0
c,d,1
e,f,2
}

  def test_8

    assert_equal CSV8.strip, Rufus::DecisionTable.new(CSV8).to_csv.strip
  end

  CSV9 = %{
    in:fx,in:fy,out:fz
    a,b,0
    c,d,${r: 1 + 2}
    e,f,2
  }

  def test_ruby_eval

    table = Rufus::Decision::Table.new(CSV9, :ruby_eval => true)

    wi = { 'fx' => 'c', 'fy' => 'd' }
    do_test(table, wi, { 'fz' => '3' }, false)
  end

  def test_ruby_eval_string_key

    table = Rufus::Decision::Table.new(CSV9, 'ruby_eval' => true)

    wi = { 'fx' => 'c', 'fy' => 'd' }
    do_test(table, wi, { 'fz' => '3' }, false)
  end

  CSV10 = %{
in:fx,in:fx,out:fz
>90,<92,ok
,,bad
}

  def test_10

    wi = { "fx" => "91" }
    do_test(CSV10, wi, { "fz" => "ok" }, false)

    wi = { "fx" => "95" }
    do_test(CSV10, wi, { "fz" => "bad" }, false)

    wi = { "fx" => "81" }
    do_test(CSV10, wi, { "fz" => "bad" }, false)
  end

  CSV11 = %{
through
in:f1,in:f1,in:f2,in:f3,out:o1,out:e1,out:e2

<100,>=95,<=2.0,<=5,"Output1",,
<100,>=95,,,"Output2",,
<100,>=95,>2.0,,"Expection1",,
<100,>=95,,>2.0,,,"Expection2"
<100,>=95,,>2.0,"Invalid",,
}

  def test_fu_zhang

    wi = { 'f1' => 97, 'f2' => 5 }
    do_test CSV11, wi, { 'o1' => 'Expection1' }, false
  end

  CSV12 = %{
accumulate
,,,
in:fx, in:fy, out:fX, out:fY
,,,
a,   ,    red,  green
,    a,   blue,   purple
b,   ,    yellow, beige
,    b,   white,  kuro
}

  def test_accumulate

    wi = { "fx" => "a", "fy" => "a" }
    do_test CSV12, wi, { "fX" => "red;blue", "fY" => "green;purple" }, false

    wi = { "fx" => "a", "fy" => "a", "fX" => "BLACK" }
    do_test CSV12, wi, {
      "fX" => "BLACK;red;blue", "fY" => "green;purple" }, false

    wi = { "fx" => "a", "fy" => "a", "fX" => [ "BLACK", "BLUE" ] }
    do_test CSV12, wi, {
      "fX" => "BLACK;BLUE;red;blue", "fY" => "green;purple" }, false
  end

  def test_to_ruby_range

    dt = Rufus::Decision::Matchers::Range.new

    assert_not_nil dt.to_ruby_range("99..100")
    assert_not_nil dt.to_ruby_range("99...100")
    assert_not_nil dt.to_ruby_range("99.12..100.56")
    assert_nil dt.to_ruby_range("99....100")
    assert_nil dt.to_ruby_range("9a9..100")
    assert_nil dt.to_ruby_range("9a9..1a00")

    assert_equal dt.to_ruby_range("a..z"), 'a'..'z'
    assert_equal dt.to_ruby_range("a..Z"), 'a'..'Z'
    assert_equal dt.to_ruby_range("a...z"), 'a'...'z'
    assert_nil dt.to_ruby_range("a..%")

    r = dt.to_ruby_range "4..6"
    assert r.include?(5)
    assert r.include?("5")
    assert (not r.include?(7))
    assert (not r.include?("7"))
  end

  CSV13 = %{
in:fx,out:fz
90..92,ok
,bad
}

  def test_range

    wi = { "fx" => "91" }
    do_test CSV13, wi, { "fz" => "ok" }, false

    wi = { "fx" => "95" }
    do_test CSV13, wi, { "fz" => "bad" }, false

    wi = { "fx" => "81" }
    do_test CSV13, wi, { "fz" => "bad" }, false
  end
end

