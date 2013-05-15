#--
# Copyright (c) 2007-2013, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++

require 'rufus/decision'
require 'ruote/participant'


module Rufus::Decision

  #
  # Decision participants were named 'CSV participants' prior to ruote 2.1.
  #
  # Make sure you have the gem "rufus-decision" installed in order to
  # use this decision participant.
  #
  #
  # == blog post
  #
  # This Rufus::Decision::Participant was introduced in the "ruote and
  # decision tables" blog post :
  #
  # http://jmettraux.wordpress.com/2010/02/17/ruote-and-decision-tables/
  #
  #
  # == example
  #
  # In this example, a participant named 'decide_team_member' is bound in the
  # ruote engine and, depending on the value of the workitem fields 'topic'
  # and region, sets the value of the field named 'team_member' :
  #
  #   require 'rufus/decision/participant'
  #
  #   engine.register_participant(
  #     :decide_team_member
  #     Rufus::Decision::Participant, :table => %{
  #       in:topic,in:region,out:team_member
  #       sports,europe,Alice
  #       sports,,Bob
  #       finance,america,Charly
  #       finance,europe,Donald
  #       finance,,Ernest
  #       politics,asia,Fujio
  #       politics,america,Gilbert
  #       politics,,Henry
  #       ,,Zach
  #     })
  #
  #   pdef = Ruote.process_definition :name => 'dec-test', :revision => '1' do
  #     sequence do
  #       decide_team_member
  #       participant :ref => '${team_member}'
  #     end
  #   end
  #
  # A process instance about the election results in Venezuela :
  #
  #   engine.launch(
  #     pdef,
  #     'topic' => 'politics',
  #     'region' => 'america',
  #     'line' => 'election results in Venezuela')
  #
  # would thus get routed to Gilbert.
  #
  # To learn more about decision tables :
  #
  # http://github.com/jmettraux/rufus-decision
  #
  #
  # == pointing to a table via a URI
  #
  # Note that you can reference the table by its URI :
  #
  #   engine.register_participant(
  #     :decide_team_member
  #     Rufus::Decision::Participant,
  #     :table => 'http://decisions.example.com/journalists.csv')
  #
  # If the table were a Google Spreadsheet, it would look like (note the
  # trailing &output=csv) :
  #
  #   engine.register_participant(
  #     :decide_team_member
  #     Rufus::Decision::Participant,
  #     :table => 'http://spreadsheets.google.com/pub?key=pCZNVR1TQ&output=csv')
  #
  class Participant
    include Ruote::LocalParticipant

    def initialize(opts={})

      @options = opts
    end

    def consume(workitem)

      table = @options['table']
      raise(ArgumentError.new("'table' option is missing")) unless table

      table = Rufus::Decision::Table.new(table, @options)

      workitem.fields = table.run(workitem.fields)

      reply_to_engine(workitem)
    end
  end
end

