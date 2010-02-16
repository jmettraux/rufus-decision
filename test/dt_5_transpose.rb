
#
# testing rufus-decision
#
# Thu Apr 23 15:18:15 JST 2009
#

require File.join(File.dirname(__FILE__), 'base.rb')


class Dt5Test < Test::Unit::TestCase

  def test_transpose_empty_array

    assert_equal([], Rufus::Decision.transpose([]))
  end

  def test_transpose_a_to_h

    assert_equal(
      [
        { 'age' => 33, 'name' => 'Jeff' },
        { 'age' => 35, 'name' => 'John' }
      ],
      Rufus::Decision.transpose([
        [ 'age', 'name' ],
        [ 33, 'Jeff' ],
        [ 35, 'John' ]
      ])
    )
  end

  def test_transpose_h_to_a

    assert_equal(
      [
        [ 'age', 'name' ],
        [ 33, 'Jeff' ],
        [ 35, 'John' ]
      ],
      Rufus::Decision.transpose([
        { 'age' => 33, 'name' => 'Jeff' },
        { 'age' => 35, 'name' => 'John' }
      ])
    )
  end

  def test_transpose_s_to_a

    assert_equal(
      [
        { 'age' => '33', 'name' => 'Jeff' },
        { 'age' => '35', 'name' => 'John' }
      ],
      Rufus::Decision.transpose(%{
        age,name
        33,Jeff
        35,John
      })
    )
  end
end

