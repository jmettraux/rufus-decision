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

      class Numeric < Matcher

        NUMERIC_COMPARISON = /^([><]=?)(.*)$/

        def matches?(cell, value)
          match = NUMERIC_COMPARISON.match(cell)
          return false if match.nil?

          comparator = match[1]
          cell = match[2]

          nvalue = Float(value) rescue value
          ncell = Float(cell) rescue cell

          value, cell = if nvalue.is_a?(::String) or ncell.is_a?(::String)
            [ "\"#{value}\"", "\"#{cell}\"" ]
          else
            [ nvalue, ncell ]
          end

          s = "#{value} #{comparator} #{cell}"

          Rufus::Decision::check_and_eval(s) rescue false
        end

        def cell_substitution?
          true
        end
      end
    end
  end
end
