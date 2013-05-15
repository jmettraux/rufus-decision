# Proposal: Set Logic Matcher

Add a set logic matcher which allows a decision table cell to match based on set logic between the decision table and the corresponding entry in the hash being transformed.


## Set Conversion on input hash

        $(bob, mary)       => Set["bob", "mary"]
        $(bob mary, jeff)  => Set["bob mary", "jeff"]
        $('bob rob', jeff) => Set["bob rob", "jeff"]
        ${r: ruby_code}    => eval ruby code, ignoring unless it returns a set
        ${other_column}    => apply set conversion to other_column
        $(${c1}, ${c2})    => Set["c1 contents", "c2 contents"]
        bob, mary          => Set["bob", "mary"]
        bob mary           => Set["bob mary"]
        'bob, mary', jeff) => Set["bob, mary", "jeff"]

## Decision Table Cell Syntax

1. The set logic matcher would apply to any cell matching the regex 

  ```ruby
  /^\$\((.*)\)/
  ```
set logic expressions could contain:

        $in                 => the hash element with this column name, with set conversion applied
        $(${c1})            => the hash element named c1, with set conversion applied
        $(${in:c1})         => the row element named in:c1, assumed to be Decision Table Cell Syntax
        $(${out:c1})         => the row element named in:c1, with set conversion applied
        $()
        $(bob, mary)       => Set["bob", "mary"]
        $(bob mary, jeff)  => Set["bob mary", "jeff"]
        $('bob rob', jeff) => Set["bob rob", "jeff"]
        $(*)               => The universal set
        $(r: ruby_code)    => eval ruby code, ignoring unless it returns a set

        #=                 => cardinality ==
        #<                 => cardinality <
        #>                 => cardinality >
        &|intersection     => intersection of sets
        +|union            => union of sets
        -|difference       => difference of sets
        <|proper_subset    => proper_subset of sets
        >|proper_superset  => proper_superset of sets
        <=|subset          => subset of sets
        >=|superset        => superset of sets
        ^                  => (set1 + set2) - (set1 & set2)

        special case: if the cell contains only a set, it is equivalent to
        $in <= $(cell)

## Examples
        $(bob jeff mary) & $in #= 2
        => does not match (bob, jeff, mary)
        => matches (bob, mary) or (jeff, mary) etc.
        => does not match (bob) or (jeff) or (mary)

        $(bob, jeff, mary)
        => matches (bob)
        => matches (jeff, mary)
        => matches (bob, jeff, mary)
        => does not match (ralph, bob)

