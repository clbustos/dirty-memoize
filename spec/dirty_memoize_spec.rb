require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class ExpensiveClass
  attr_writer :x, :y
  attr_reader :count
  include DirtyMemoize
  def initialize
    @a=nil
    @b=nil
    @x='x'
    @y='y'
    @compute_called=false
  end
  def set_a(aa)
    @a=aa
  end
  def compute_called?
    @compute_called
  end
  def compute
    @a=@x
    @b=@y
    @compute_called=true
  end
  def a
    "@a=#{@a}"
  end
  def b
    "@b=#{@b}"
  end    
  dirty_writer :x, :y
  dirty_memoize :a, :b
end

class ExpensiveClass2 < ExpensiveClass
  DIRTY_COMPUTE=:compute2
  def compute2
    @a=@x+".2"
  end
end
describe DirtyMemoize, "extended object" do
  before(:each) do
    @ec=ExpensiveClass.new
  end
  it "should initialize with dirty? to true" do 
    @ec.dirty?.should==true
  end
  it "should initialize with number of computation to 0" do
    @ec.compute_count.should==0
  end
  describe "reads 'dirty' attributes " do
    before(:each) do
      @ec.a
    end
    it "#compute is called" do
      @ec.compute_called?.should==true
    end
    it 'compute_count set to 1' do
      @ec.compute_count.should==1
    end
    it 'dirty? set to false' do
      @ec.dirty?.should==false
    end
    it "compute_count doesn't change with multiple calls" do
      5.times {@ec.a}
      @ec.compute_count.should==1
    end
  end
  describe "calls dirty writers before dirty getter" do
    before(:each) do
      @ec.x="cache"
    end
    it 'set dirty? to true' do
      @ec.dirty?.should==true
    end
    it "doesn't call compute" do
      @ec.compute_called?.should==false
    end
    it "doesn't change dirty getters" do
      @ec.instance_variable_get("@a").nil?.should==true
    end
  end
  
  describe "calls dirty getter after call dirty writer" do
    before(:each) do
      @ec.x="cache"
      @ec.a
    end
    it 'set dirty? to false' do
      @ec.dirty?.should==false
    end    
    it "calls compute, only once" do
      @ec.compute_called?.should==true
      @ec.compute_count.should==1      
    end
    it "set value or internal variable" do
      @ec.instance_variable_get("@a").should=='cache'
    end
    it 'set getter method with a different value' do
      @ec.a.should=='@a=cache'
    end
  end
  describe "uses cache" do
    before(:each) do
      @ec.x='cache'
      @ec.a
      @ec.set_a('not_cache')
    end
    it "so changing internal variables  doesn't produce external changes" do 
      @ec.instance_variable_get("@a").should=='not_cache'
      @ec.compute_count.should==1
      @ec.a.should=='@a=cache'
    end
    it "so deleting it implies calculate all again" do
      @ec.dirty?.should==false
      @ec.clean_cache
      @ec.dirty?.should==true
      @ec.compute_count.should==1
      @ec.a.should=='@a=cache'
      @ec.compute_count.should==2
      
    end
  end
  describe "could call other computation method" do 
    it "using DIRTY_COMPUTER" do
      @ec2=ExpensiveClass2.new
      @ec2.x='cache'
      @ec2.a.should=='@a=cache.2'
      @ec2.compute_count.should==1
      
    end
  end
end
