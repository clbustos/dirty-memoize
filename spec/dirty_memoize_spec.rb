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
  subject { @ec }
  context "when instanciated" do 
	  it { should be_dirty}
	  it "should initialize with number of computation to 0" do
		@ec.compute_count.should==0
	  end
	  it "read inmediatly the correct value" do
		@ec.a=='x'
	end
  end
  context "when reads 'dirty' attributes " do
    before(:each) do
      @ec.a
    end
    it {should be_compute_called} 

	it '#compute_count set to 1' do
      @ec.compute_count.should==1
	end
  
	it{ should_not be_dirty}
    
    it "compute_count doesn't change with multiple calls" do
      5.times {@ec.a}
      @ec.compute_count.should==1
    end
  end
  context "calls dirty writers before dirty getter" do
    before(:each) do
      @ec.x="cache"
    end
	it { should be_dirty}
	it { should_not be_compute_called}

    it "doesn't change dirty getters" do
      @ec.instance_variable_get("@a").should be_nil
    end
  end
  
  describe "calls dirty getter after call dirty writer" do
    before(:each) do
      @ec.x="cache"
      @ec.a
    end
	specify { @ec.should_not be_dirty}
    it "calls compute, only once" do
      @ec.compute_called?.should==true
      @ec.compute_count.should==1      
    end
    it "set value of internal variable" do
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
    it "can change internal variables" do 
      @ec.instance_variable_get("@a").should=='not_cache'
  end
    it "shouldn't compute new values" do 
      @ec.compute_count.should==1
  end
    it {should_not be_dirty}
    it "doesn't change cache value" do
      @ec.a.should=='@a=cache'
	end
   
    it "so deleting it implies calculate all again" do
      @ec.clean_cache
      @ec.should be_dirty
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
