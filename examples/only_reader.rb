$:.unshift(File.expand_path(File.dirname(__FILE__)+"/../lib"))
# This example shows the use of dirty_memoize without dirty_writer.
# When we call the method marked with dirty_memoize on a dirty object
# compute method is called. 

require 'dirty-memoize'

class Factorial
  include DirtyMemoize
  attr_reader :result
  dirty_memoize :result
  def initialize(n)
    @n=n
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

a=Factorial.new(10)
puts "Our object is dirty: #{a.dirty?}"
puts "The result is: #{a.result}"
puts "Our object is no longer dirty: #{a.dirty?}"
puts "And the result is cached without calling the compute method: #{a.result}"
a.clean_cache
# Object is now dirty. So, compute will be called when we get result
puts "The result is: #{a.result}"

