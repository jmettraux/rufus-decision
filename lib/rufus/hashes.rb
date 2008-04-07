#
#--
# Copyright (c) 2008, John Mettraux, jmettraux@gmail.com
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
#++
#

#
# "made in Japan"
#
# John Mettraux at openwfe.org
#

require 'rubygems'
require 'rufus/eval'


module Rufus

    #
    # In the Java world, this class would be considered abstract.
    #
    # It's used to build sequences of filter on hashes (or instances 
    # that respond to the [], []=, has_key? methods).
    #
    # It relies on 'prefixed string keys' like "x:y", where the prefix is 'x'
    # and the partial key is then 'y'.
    #
    # Rufus::EvalHashFilter is an implementation of an HashFilter.
    #
    class HashFilter

        def initialize (parent_hash)

            @parent_hash = parent_hash
        end

        def [] (key)

            p, k = do_split(key)

            do_lookup(key, p, k)
        end

        def []= (key, value)

            p, v = do_split(value)

            do_put(key, value, p, v)
        end

        protected

            def do_split (element)

                return [ nil, element ] unless element.is_a?(String)

                a = element.split(':', 2)
                return [ nil ] + a if a.length == 1
                a
            end

            def handles_prefix? (p)

                false
            end

            def do_eval (key, p, k)

                raise NotImplementedError.new(
                    "missing do_eval(key, p, k) implementation")
            end

            def do_lookup (key, p, k)

                if handles_prefix?(p)

                    do_eval(key, p, k)

                elsif @parent_hash.respond_to?(:do_lookup)

                    @parent_hash.do_lookup key, p, k

                else

                    @parent_hash[key]
                end
            end

            def do_put (key, value, p, v)

                val = value

                if handles_prefix?(p)

                    @parent_hash[key] = do_eval(value, p, v)

                elsif @parent_hash.respond_to?(:do_put)

                    @parent_hash.do_put key, value, p, v

                else

                    @parent_hash[key] = value
                end
            end
    end

    #
    # Implements the r:, ruby: and reval: prefixes in lookups
    # 
    #     require 'rubygems'
    #     require 'rufus/hashes'
    #
    #     h = {}
    #
    #     eh = Rufus::EvalHashFilter.new(h, 0)
    #
    #     eh['a'] = :a
    #     p h # => { 'a' => :a }
    #
    #     eh['b'] = "r:5 * 5"
    #     p h # => { 'a' => :a, 'b' => 25 }
    #
    #     assert_equal :a, eh['a']
    #     assert_equal 25, eh['b']
    #     assert_equal 72, eh['r:36+36']
    #
    class EvalHashFilter < HashFilter

        def initialize (parent_hash, eval_safety_level=0)

            super parent_hash
            @safe_level = eval_safety_level
        end

        protected

            RP = [ 'r', 'ruby', 'reval' ]

            def handles_prefix? (prefix)

                RP.include?(prefix)
            end

            #
            # Ready for override.
            #
            def get_binding

                binding()
            end

            def do_eval (key, p, k)

                Rufus::eval_safely(k, @safe_level, get_binding)
            end
    end

    private

        def Rufus.unescape (text)

            text.gsub("\\\\\\$\\{", "\\${")
        end

end

