
#
# testing rufus-decision (ruote participant)
#
# Tue Feb 16 14:54:55 JST 2010
#

require File.join(File.dirname(__FILE__), 'base')

require 'rufus/decision/participant'

class Rt0Test < Test::Unit::TestCase
  include RuoteBase

  def test_basic

    @engine.register_participant(
      :decision,
      Rufus::Decision::Participant, :table => %{
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

    pdef = Ruote.process_definition :name => 'dec-test', :revision => '1' do
      decision
    end

    wfid = @engine.launch(pdef, 'topic' => 'politics', 'region' => 'america')
    r = @engine.wait_for(wfid)

    assert_equal(
      {"topic"=>"politics", "region"=>"america", "team_member"=>"Gilbert"},
      r['workitem']['fields'])
  end
end

