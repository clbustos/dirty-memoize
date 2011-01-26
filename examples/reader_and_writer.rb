$:.unshift(File.expand_path(File.dirname(__FILE__)+"/../lib"))
# This example shows the use of dirty_memoize with dirty_writer.
# When we call the method marked with dirty_memoize on a dirty object,
# compute method is called. 
# Setting a value on a dirty_writer set the object to dirty

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

