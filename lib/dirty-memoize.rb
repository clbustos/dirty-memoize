# Like Memoize, but designed for mutable and parametizable objects
# 
# Use when: 
# 1. You have one expensive method (\#compute) which set many internal
#    variables. So, is preferable lazy evaluation of these dependent variables.
# 2. The expensive operation depends on one or more parameters
# 3. Changes on one or more parameters affect all dependent variables
# 4. You may want to hide the call of 'compute' operation
# 5. The user could want test several different parameters values
#  
# By default, the method to compute should be called \#compute. 
# Set constant DIRTY_COMPUTE to the name of other method if you need it
#
# Example:
#  class ExpensiveCalculation
#   extend DirtyMemoize
#   attr_accessor :y, :z
#   def initialize(y=nil,z=nil)
#     @y=y
#     @z=z
#   def compute
#     @a=@y*1000+@z*1000
#   end
#   def a
#      @a.nil? nil : "This is the value: #{@a}"
#   end
# 
#  end
#  puts ExpensiveCalculation.new(1,2).a

module DirtyMemoize
  VERSION="0.0.4"
  # Trick from http://github.com/ecomba/memoizable
  def self.included(receiver) #:nodoc:
    receiver.extend DirtyMemoize::ClassMethods
  end
  module ClassMethods
    # Set variables which 
    def dirty_writer(*independent)
      independent.each do |sym|
        sym=sym.to_s+"="
        alias_method((sym.to_s+"_without_dirty").intern, sym)
        define_method(sym) do |*args|
          @dirty=:true
          send(sym.to_s+"_without_dirty", *args)
        end
      end
    end
    
    def dirty_memoize(*dependent)
      dependent.each do |sym|
        alias_method((sym.to_s+"_without_dirty").intern, sym)
        define_method(sym) do |*args|
          if(dirty?)
            clean_cache
            if self.class.const_defined? "DIRTY_COMPUTE"
              send(self.class.const_get("DIRTY_COMPUTE"))
            else
              send(:compute)
            end
            @compute_count||=0
            @compute_count+=1
            @dirty=:false
          end
          @cache[sym]||=Hash.new
          @cache[sym][args]||=send(sym.to_s+"_without_dirty", *args)
        end
      end
    end
  end # end of ClassMethods
  # Is the object dirty?
  def dirty?
    @dirty||=:true
    @dirty==:true
  end
  # Number of compute's runs
  def compute_count
    @compute_count||=0
  end
  def clean_cache
    @cache=Hash.new
    @dirty=:true
  end
  
end