
= rufus-decision


== getting it

  sudo gem install -y rufus-decision

or at

http://rubyforge.org/frs/?group_id=4812

== intro blog post

http://jmettraux.wordpress.com/2009/04/25/rufus-decision-11-ruby-decision-tables/

== usage

More info at http://rufus.rubyforge.org/rufus-decision/classes/Rufus/Decision/Table.html but here is a recap.

An example where a few rules determine which salesperson should interact with a customer with given characteristics.


  require 'rubygems'
  require 'rufus/decision'
  
  TABLE = Rufus::Decision::Table.new(%{
    in:age,in:trait,out:salesperson
    
    18..35,,adeslky
    25..35,,bronco
    36..50,,espadas
    51..78,,thorsten
    44..120,,ojiisan
    
    25..35,rich,kerfelden
    ,cheerful,swanson
    ,maniac,korolev
  })
  
  # Given a customer (a Hash instance directly, for 
  # convenience), returns the name of the first 
  # corresponding salesman.
  #
  def determine_salesperson (customer)
  
    TABLE.transform(customer)["salesperson"]
  end
  
  puts determine_salesperson(
    "age" => 72) # => thorsten
  
  puts determine_salesperson(
    "age" => 25, "trait" => "rich") # => adeslky
  
  puts determine_salesperson(
    "age" => 23, "trait" => "cheerful") # => adeslky
  
  puts determine_salesperson(
    "age" => 25, "trait" => "maniac") # => adeslky
  
  puts determine_salesperson(
    "age" => 44, "trait" => "maniac") # => espadas


More at Rufus::Decision::Table

Note that you can use a CSV table served over HTTP like in :

  
  require 'rubygems'
  require 'rufus/decision'
  
  TABLE = Rufus::DecisionTable.new(
    'http://spreadsheets.google.com/pub?key=pCkopoeZwCNsMWOVeDjR1TQ&output=csv')
  
  # the CSV is :
  #
  # in:weather,in:month,out:take_umbrella?
  #
  # raining,,yes
  # sunny,,no
  # cloudy,june,yes
  # cloudy,may,yes
  # cloudy,,no
  
  def take_umbrella? (weather, month=nil)
    h = TABLE.transform('weather' => weather, 'month' => month)
    h['take_umbrella?'] == 'yes'
  end
  
  puts take_umbrella?('cloudy', 'june')
    # => true
  
  puts take_umbrella?('sunny', 'june')
    # => false

In this example, the CSV table is the direction CSV representation of the Google spreadsheet at : http://spreadsheets.google.com/pub?key=pCkopoeZwCNsMWOVeDjR1TQ

WARNING though : use at your own risk. CSV loaded from untrusted locations may contain harmful code. The rufus-decision gem has an abstract tree checker integrated, it will check all the CSVs that contain calls in Ruby and raise a security error when possibly harmful code is spotted. Bullet vs Armor. Be warned.


== uninstalling it

    sudo gem uninstall -y rufus-decision


== dependencies

The gem 'rufus-dollar' (http://rufus.rubyforge.org/rufus-dollar) and the 'rufus-treechecker' gem (http://rufus.rubyforge.org/rufus-treechecker).


== mailing list

On the rufus-ruby list :

http://groups.google.com/group/rufus-ruby


== irc

irc.freenode.net #ruote


== issue tracker

http://rubyforge.org/tracker/?atid=18584&group_id=4812&func=browse


== source

http://github.com/jmettraux/rufus-decision

  git clone git://github.com/jmettraux/rufus-decision.git


== author

John Mettraux, jmettraux@gmail.com 
http://jmettraux.wordpress.com


== the rest of Rufus

http://rufus.rubyforge.org


== license

MIT

