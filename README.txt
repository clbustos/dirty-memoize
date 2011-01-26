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
 
  class ExpensiveCalculation
   include DirtyMemoize
   attr_reader :a
   attr_accesor :x
   # Your evil function
   def compute
     @a=x**x**x
   end
  end
  a=new ExpensiveCalculation
  a.x=1
  puts a.a

== Sugestions

* Fork, modify and do wathever you need with it. 

== Copyright

Copyright (c) 2010-2011 Claudio Bustos. See LICENSE for details.