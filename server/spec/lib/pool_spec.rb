# encoding: utf-8
#
require 'spec_helper'

describe Picky::Pool do
  
  class PoolTest
    extend Picky::Pool
    
    attr_reader :number
    
    def initialize number
      @number = number
    end
  end
  class OtherPoolTest
    extend Picky::Pool
    
    attr_reader :number
    
    def initialize number
      @number = number
    end
  end
  
  context 'functional' do
    before(:each) do
      described_class.clear
      PoolTest.clear
      OtherPoolTest.clear
    end
    it 'lets me get an instance' do
      PoolTest.obtain(1).should be_kind_of(PoolTest)
    end
    it 'does not create a new reference if it has free ones' do
      pt1 = PoolTest.obtain 1
      pt2 = PoolTest.obtain 2
      pt1.release
      
      PoolTest.free_size.should == 1
    end
    it 'gives me the released reference if I try to obtain' do
      pt1 = PoolTest.obtain 1
      pt2 = PoolTest.obtain 2
      pt1.release
      
      PoolTest.obtain(3).number.should == 3
    end
    it 'releases all PoolTests if called on PoolTest' do
      pt1 = PoolTest.obtain 1
      PoolTest.obtain 2
      OtherPoolTest.obtain 1
      OtherPoolTest.obtain 2
      
      OtherPoolTest.free_size.should == 0 
      
      PoolTest.release_all
      
      PoolTest.obtain(3).should == pt1
      OtherPoolTest.free_size.should == 0
    end
    it 'releases all if called on Pool' do
      PoolTest.obtain 1
      PoolTest.obtain 2
      OtherPoolTest.obtain 1
      OtherPoolTest.obtain 2
      
      PoolTest.free_size.should == 0
      
      described_class.release_all
      
      PoolTest.free_size.should == 2
    end
  end
  
end