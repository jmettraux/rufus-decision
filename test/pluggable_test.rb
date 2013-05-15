
require File.expand_path('../base.rb', __FILE__)


class PluggableTest < Test::Unit::TestCase

  def test_default_matchers
    table = Rufus::Decision::Table.new("\n")

    assert table.matchers[0].is_a?(
      Rufus::Decision::Matchers::Numeric)
    assert table.matchers[1].is_a?(
      Rufus::Decision::Matchers::Range)
    assert table.matchers[2].is_a?(
      Rufus::Decision::Matchers::String)
  end
end

