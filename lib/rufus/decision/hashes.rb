#--
# Copyright (c) 2008-2013, John Mettraux, jmettraux@gmail.com
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


require 'fileutils'
require 'rufus/treechecker'


module Rufus
module Decision

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

    attr_reader :parent_hash

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

        @parent_hash.do_lookup(key, p, k)

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
  #   require 'rubygems'
  #   require 'rufus/decision/hashes'
  #
  #   h = {}
  #
  #   eh = Rufus::Decision::EvalHashFilter.new(h)
  #
  #   eh['a'] = :a
  #   p h # => { 'a' => :a }
  #
  #   eh['b'] = "r:5 * 5"
  #   p h # => { 'a' => :a, 'b' => 25 }
  #
  #   assert_equal :a, eh['a']
  #   assert_equal 25, eh['b']
  #   assert_equal 72, eh['r:36+36']
  #
  class EvalHashFilter < HashFilter

    def initialize (parent_hash)

      super(parent_hash)
    end

    protected

    RP = %w{ r ruby reval }

    def handles_prefix? (prefix)

      RP.include?(prefix)
    end

    # Ready for override.
    #
    def get_binding

      binding()
    end

    def do_eval (key, p, k)

      Rufus::Decision.check_and_eval(k, get_binding)
    end
  end

  # An abstract syntax tree check (prior to any ruby eval)
  #
  TREECHECKER = Rufus::TreeChecker.new do

    exclude_fvccall :abort, :exit, :exit!
    exclude_fvccall :system, :fork, :syscall, :trap, :require, :load

    #exclude_call_to :class
    exclude_fvcall :private, :public, :protected

    exclude_def               # no method definition
    exclude_eval              # no eval, module_eval or instance_eval
    exclude_backquotes        # no `rm -fR the/kitchen/sink`
    exclude_alias             # no alias or aliast_method
    exclude_global_vars       # $vars are off limits
    exclude_module_tinkering  # no module opening
    exclude_raise             # no raise or throw

    exclude_rebinding Kernel # no 'k = Kernel'

    exclude_access_to(
      IO, File, FileUtils, Process, Signal, Thread, ThreadGroup)

    exclude_class_tinkering

    exclude_call_to :instance_variable_get, :instance_variable_set
  end
  TREECHECKER.freeze

  # Given a string (of ruby code), first makes sure it doesn't contain
  # harmful code, then evaluates it.
  #
  def self.check_and_eval (ruby_code, bndng=binding())

    TREECHECKER.check(ruby_code)

    # OK, green for eval...

    eval(ruby_code, bndng)
  end

end
end

