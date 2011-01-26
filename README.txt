= dirty-memoize

* http://github.com/clbustos/dirty-memoize

==DESCRIPTION 

Like Memoize, but designed for mutable and parametizable objects

Use when: 
1. You have one expensive method (\compute) which set many internal
   variables. So, is preferable lazy evaluation of these dependent variables.
2. The expensive operation depends on one or more parameters
3. Changes on one or more parameters affect all dependent variables
4. You may want to hide the call of 'compute' operation
5. The user could want test several different parameters values

== SYNOPSIS

By default, the method to compute should be called \#compute. 
Set constant DIRTY_COMPUTE to the name of other method if you need it

Example:
 
    require 'dirty-memoize'
    
    class Factorial
    include DirtyMemoize
    attr_reader :result
    attr_writer :n
    dirty_memoize :result
    dirty_writer :n
    
    def initialize
    @n=nil
    @result=nil
    end
    def fact(n)
    return 1 if n==1
    n*(fact(n-1))
    end
    def compute
    puts "Computing the factorial!"
    @result=fact(@n)
    end
    end
    
    a=Factorial.new
    a.n=10
    puts "Our object is dirty: #{a.dirty?}"
    puts "The result is: #{a.result}"
    puts "Our object is no longer dirty: #{a.dirty?}"
    puts "And the result is cached without calling the compute method: #{a.result}"
    puts "Now, n is changed to 5"
    a.n=5
    # Object is now dirty. So, compute will be called when we get result
    puts "The result is: #{a.result}"

== Sugestions

* Fork, modify and do wathever you need with it. 

== Copyright

Copyright (c) 2010-2011 Claudio Bustos. See LICENSE for details.
