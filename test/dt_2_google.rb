
#
# testing rufus-decision
#
# Sun Oct 29 15:41:44 JST 2006
#

require File.join(File.dirname(__FILE__), 'base.rb')


class Dt2Test < Test::Unit::TestCase
  include DecisionTestMixin

  CSV3D = 'https://spreadsheets.google.com/pub?key=pCkopoeZwCNsMWOVeDjR1TQ&output=csv&gid=0'

  def test_3d

    return if ENV['SKIP_RUFUS_SLOW']

    h = {}
    h["weather"] = "raining"
    h["month"] = "december"

    do_test(CSV3D, h, { "take_umbrella?" => "yes" }, false)

    h = {}
    h["weather"] = "cloudy"
    h["month"] = "june"

    sleep 0.3 # don't request the doc too often

    do_test(CSV3D, h, { "take_umbrella?" => "yes" }, false)

    h = {}
    h["weather"] = "cloudy"
    h["month"] = "march"

    sleep 0.3 # don't request the doc too often

    do_test(CSV3D, h, { "take_umbrella?" => "no" }, false)
  end
end

