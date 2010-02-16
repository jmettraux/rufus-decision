
require 'rubygems'
require 'rufus/decision' # sudo gem install rufus-decision

table = %{
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
}

#Rufus::Decision.csv_to_a(table).transpose.each do |row|
#  puts row.join(', ')
#end
table = %{
  in:topic,sports,sports,finance,finance,finance,politics,politics,politics,
  in:region,europe,,america,europe,,asia,america,,
  out:team_member,Alice,Bob,Charly,Donald,Ernest,Fujio,Gilbert,Henry,Zach
}

table = Rufus::Decision::Table.new(table)

p table.run('topic' => 'politics', 'region' => 'america')
  # => {"region"=>"america", "topic"=>"politics", "team_member"=>"Gilbert"}

p table.run('topic' => 'sports', 'region' => 'antarctic')
  # => {"region"=>"antarctic", "topic"=>"sports", "team_member"=>"Bob"}

p table.run('topic' => 'culture', 'region' => 'america')
  # => {"region"=>"america", "topic"=>"culture", "team_member"=>"Zach"}

