
= rufus-decision


== getting it

    sudo gem install -y rufus-decision

or at

http://rubyforge.org/frs/?group_id=4812


== usage

An example where a few rules determine which salesperson should interact with a customer with given characteristics.


    require 'rubygems'
    require 'rufus/decision'
    
    include Rufus
    
    TABLE = DecisionTable.new("""
    in:age,in:trait,out:salesperson
    
    18..35,,adeslky
    25..35,,bronco
    36..50,,espadas
    51..78,,thorsten
    44..120,,ojiisan
    
    25..35,rich,kerfelden
    ,cheerful,swanson
    ,maniac,korolev
    """)
    
    #
    # Given a customer (a Hash instance directly, for 
    # convenience), returns the name of the first 
    # corresponding salesman.
    #
    def determine_salesperson (customer)
    
        TABLE.transform(customer)["salesperson"]
    end
    
    puts determine_salesperson(
        "age" => 72)
        # => thorsten
    
    puts determine_salesperson(
        "age" => 25, "trait" => "rich")
        # => adeslky
    
    puts determine_salesperson(
        "age" => 23, "trait" => "cheerful")
        # => adeslky
    
    puts determine_salesperson(
        "age" => 25, "trait" => "maniac")
        # => adeslky
    
    puts determine_salesperson(
        "age" => 44, "trait" => "maniac")
        # => espadas


More at Rufus::DecisionTable


= dependencies

The gem 'rufus-dollar' (http://rufus.rubyforge.org/rufus-dollar) and the 'rufus-eval' gem (http://rufus.rubyforge.org/rufus-eval).


== mailing list

On the rufus-ruby list[http://groups.google.com/group/rufus-ruby] :

    http://groups.google.com/group/rufus-ruby


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

