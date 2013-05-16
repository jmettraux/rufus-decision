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


module Rufus
  module Decision
    module Matchers

      class Range < Matcher

        # A regexp for checking if a string is a numeric Ruby range
        #
        RUBY_NUMERIC_RANGE_REGEXP = Regexp.compile(
          "^\\d+(\\.\\d+)?\\.{2,3}\\d+(\\.\\d+)?$")

        # A regexp for checking if a string is an alpha Ruby range
        #
        RUBY_ALPHA_RANGE_REGEXP = Regexp.compile(
          "^([A-Za-z])(\\.{2,3})([A-Za-z])$")

        # If the string contains a Ruby range definition
        # (ie something like "93.0..94.5" or "56..72"), it will return
        # the Range instance.
        # Will return nil else.
        #
        # The Ruby range returned (if any) will accept String or Numeric,
        # ie (4..6).include?("5") will yield true.
        #
        def to_ruby_range(s)

          range = if RUBY_NUMERIC_RANGE_REGEXP.match(s)

            eval(s)

          else

            m = RUBY_ALPHA_RANGE_REGEXP.match(s)

            m ? eval("'#{m[1]}'#{m[2]}'#{m[3]}'") : nil
          end

          class << range

            alias :old_include? :include?

            def include? (elt)
              elt = first.is_a?(::Numeric) ? (Float(elt) rescue '') : elt
              old_include?(elt)
            end

          end if range

          range
        end

        def matches?(cell, value)

          range = to_ruby_range(cell)

          range && range.include?(value)
        end
      end
    end
  end
end
