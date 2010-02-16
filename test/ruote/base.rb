
#
# testing rufus-decision (ruote participant)
#
# Tue Feb 16 14:37:13 JST 2010
#

$:.unshift(
  File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. lib ])))
$:.unshift(
  File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. .. .. ruote lib ])))

require 'test/unit'
require 'rubygems'
require 'ruote'
require 'rufus/decision'


module RuoteBase

  def setup

    @engine =
      Ruote::Engine.new(
        Ruote::Worker.new(
          Ruote::HashStorage.new(
            's_logger' => %w[ ruote/log/test_logger Ruote::TestLogger ])))
  end

  def teardown

    @engine.shutdown
    @engine.context.storage.purge!
  end
end

