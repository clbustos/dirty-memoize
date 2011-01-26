require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class ExpensiveClass
  attr_writer :x, :y
  include DirtyMemoize
  def initialize
    @a=nil
    @b=nil
    @x='x'
    @y='y'
  end
  def set_a(aa)
    @a=aa
  end
  def compute
    @a=@x
    @b=@y
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
  before do
    @ec=ExpensiveClass.new
  end
  subject { @ec }
  context "when instanciated" do 
	  it { should be_dirty}
	  it "should initialize with number of computation to 0" do
		  @ec.compute_count.should==0
	  end
	  it "read inmediatly the correct value" do
		  @ec.a.should=='@a=x'
	  end
  end
  context "when reads 'dirty' attributes " do
    before do
      @ec.a
    end
	  it 'call compute' do
      @ec.compute_count.should==1
	  end
	  it{ should_not be_dirty}
    it "call compute once and only once" do
      5.times {@ec.a}
      @ec.compute_count.should==1
    end
  end
  context "calls dirty writers before dirty getter" do
    before do
      @ec.x="cache"
    end
	  it { should be_dirty}
    it "doesn't compute anything" do
      @ec.compute_count.should==0
    end
    it "doesn't change internal variables" do
      @ec.instance_variable_get("@a").should be_nil
    end
  end
  
  describe "when calls dirty getter after call dirty writer" do
    before do
      @ec.x="cache"
      @ec.a
    end
	  it { @ec.should_not be_dirty}
    it "calls compute only once" do
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
    before do
      @ec.x='cache'
      @ec.a
      @ec.set_a('not_cache')
    end
    it "changing internal doesn't start compute" do 
      @ec.compute_count.should==1
    end
    it {should_not be_dirty}
    it "doesn't change cache value" do
      @ec.a.should=='@a=cache'
	  end
    describe "when cleaning cache" do
      before do
        @ec.clean_cache
      end
      it {@ec.should be_dirty}
      it "doesn't call compute" do
        @ec.compute_count.should==1
      end
      describe "when get dirty attribute" do
        it "returns correct value and call compute again" do
          @ec.a.should=='@a=cache'
          @ec.compute_count.should==2
        end
      end
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
