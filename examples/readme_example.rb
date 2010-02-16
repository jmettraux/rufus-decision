
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

