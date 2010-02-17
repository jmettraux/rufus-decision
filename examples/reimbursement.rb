
#
# ruote + rufus-decision example
#
# featured in
#
#   http://jmettraux.wordpress.com/2010/02/17/ruote-and-decision-tables/
#

require 'rubygems'


#
# preparing the workflow engine

require 'ruote'

engine = Ruote::Engine.new(Ruote::Worker.new(Ruote::HashStorage.new()))
  # for this example we use a transient, in-memory engine

#engine.context.logger.noisy = true
  # useful when debugging


#
# the process definition

pdef = Ruote.process_definition :name => 'reimbursement', :revision => '1.0' do
  cursor do
    customer :task => 'fill form'
    clerk :task => 'control form'
    rewind :if => '${f:missing_info}'
    determine_reimbursement_level
    finance :task => 'reimburse customer'
    customer :task => 'reimbursement notification'
  end
end


#
# the 'inbox/worklist' participant
#
# for this example, they are only STDOUT/STDIN participants

class StdoutParticipant
  include Ruote::LocalParticipant

  def initialize (opts)
  end

  def consume (workitem)

    puts '-' * 80
    puts "participant : #{workitem.participant_name}"

    if workitem.fields['params']['task'] == 'fill form'
      puts " * reimbursement claim, please fill details :"
      echo "description : "
      workitem.fields['description'] = STDIN.gets.strip
      echo "type of visit (doctor office / hospital visit / lab visit) : "
      workitem.fields['type of visit'] = STDIN.gets.strip
      echo "participating physician ? (yes or no) : "
      workitem.fields['participating physician ?'] = STDIN.gets.strip
    else
      puts " . reimbursement claim :"
      workitem.fields.each do |k, v|
        puts "#{k} --> #{v.inspect}"
      end
    end

    reply_to_engine(workitem)
  end

  def echo (s)
    print(s); STDOUT.flush
  end
end

engine.register_participant 'customer', StdoutParticipant
engine.register_participant 'clerk', StdoutParticipant
engine.register_participant 'finance', StdoutParticipant


#
# the "decision" participant

#engine.register_participant 'determine_reimbursement_level' do |workitem|
#  workitem.fields['reimbursement'] =
#    case workitem.fields['type of visit']
#      when 'doctor office'
#        workitem.fields['participating physician ?'] == 'yes' ? '90%' : '50%'
#      when 'hospital visit'
#        workitem.fields['participating physician ?'] == 'yes' ? '0%' : '80%'
#      when 'lab visit'
#        workitem.fields['participating physician ?'] == 'yes' ? '0%' : '70%'
#      else
#        '0%'
#    end
#end

require 'rufus/decision/participant'

#engine.register_participant(
#  'determine_reimbursement_level',
#  Rufus::Decision::Participant,
#  :table => %{
#in:type of visit,in:participating physician ?,out:reimbursement
#doctor office,yes,90%
#doctor office,no,50%
#hospital visit,yes,0%
#hospital visit,no,80%
#lab visit,yes,0%
#lab visit,no,70%
#  })

engine.register_participant(
  'determine_reimbursement_level',
  Rufus::Decision::Participant,
  :table => 'http://github.com/jmettraux/rufus-decision/raw/master/examples/reimbursement2.csv')


#
# running the example...

puts '=' * 80
puts "launching process"

wfid = engine.launch(pdef)

engine.wait_for(wfid)
  # don't let the Ruby runtime exits until our [unique] process instance is over

#ps = engine.process(wfid)
#if ps
#  puts ps.errors.first.message
#  puts ps.errors.first.trace
#end
  # useful when debugging

puts '=' * 80
puts "done."

