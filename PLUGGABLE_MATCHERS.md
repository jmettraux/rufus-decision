# Proposal: Pluggable Matchers

1. add attr_accessor :matchers to Table
2. create Matcher class:
  1. matches?
  1. dsub? # make the dsub step optional for a matcher
3. extract NumericComparisonMatcher
  1. add to default matchers
4. extract RangeMatcher
  1. add to default matchers
5. extract StringComparisonMatcher
  1. add to default matchers
