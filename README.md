
# rufus-decision

CSV based Ruby decision tables


## getting it

```
  gem install rufus-decision
```

or add ```gem 'rufus-decision'``` to your Gemfile.


## blog posts

* http://jmettraux.wordpress.com/2009/04/25/rufus-decision-11-ruby-decision-tables/
* http://jmettraux.wordpress.com/2010/02/17/ruote-and-decision-tables/


## usage

More info at http://rufus.rubyforge.org/rufus-decision/Rufus/Decision/Table.html but here is a recap.

An example where a few rules determine which salesperson should interact with a customer with given characteristics.


```ruby
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
```

More at Rufus::Decision::Table

Note that you can use a CSV table served over HTTP like in :

```ruby
  require 'rubygems'
  require 'rufus/decision'

  TABLE = Rufus::DecisionTable.new(
    'https://spreadsheets.google.com/pub?key=pCkopoeZwCNsMWOVeDjR1TQ&output=csv')

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
```

In this example, the CSV table is the direction CSV representation of the Google spreadsheet at : https://spreadsheets.google.com/pub?key=pCkopoeZwCNsMWOVeDjR1TQ

WARNING though : use at your own risk. CSV loaded from untrusted locations may contain harmful code. The rufus-decision gem has an abstract tree checker integrated, it will check all the CSVs that contain calls in Ruby and raise a security error when possibly harmful code is spotted. Bullet vs Armor. Be warned.

### redirections

(Courtesy of [lastobelus](https://github.com/lastobelus))

To help with redirections, one can modify the above example into:

```ruby
  require 'rubygems'
  require 'rufus/decision'

  require 'open_uri_redirections'
    # https://github.com/jaimeiniesta/open_uri_redirections

  TABLE = Rufus::DecisionTable.new(
    'http://spreadsheets.google.com/pub?key=pCkopoeZwCNsMWOVeDjR1TQ&output=csv',
    :open_uri => { :allow_redirections => :safe })
```


## web demo

There is a small demo of an input table + a decision table. You can run it by doing :

```
  # (ouch, kind of old style...)

  gem install sinatra
  git clone git://github.com/jmettraux/rufus-decision.git
  cd rufus-decision
  ruby demo/start.rb
```

and then point your browser to http://localhost:4567/


## dependencies

The gem 'rufus-dollar' (http://rufus.rubyforge.org/rufus-dollar) and the 'rufus-treechecker' gem (http://rufus.rubyforge.org/rufus-treechecker).


## mailing list

On the rufus-ruby list : http://groups.google.com/group/rufus-ruby


## irc

irc.freenode.net #ruote


## issue tracker

https://github.com/jmettraux/rufus-decision/issues


## source

https://github.com/jmettraux/rufus-decision

```
  git clone git://github.com/jmettraux/rufus-decision.git
```


## author

John Mettraux, jmettraux@gmail.com
http://jmettraux.wordpress.com


## license

MIT

