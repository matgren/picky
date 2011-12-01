# encoding: utf-8
#
require 'spec_helper'

describe 'Search#terminate_early' do

  it 'terminates early' do
    index = Picky::Index.new :terminate_early do
      category :text1
      category :text2
      category :text3
      category :text4
    end

    thing = Struct.new :id, :text1, :text2, :text3, :text4
    index.add thing.new(1, 'hello', 'hello', 'hello', 'hello')
    index.add thing.new(2, 'hello', 'hello', 'hello', 'hello')
    index.add thing.new(3, 'hello', 'hello', 'hello', 'hello')
    index.add thing.new(4, 'hello', 'hello', 'hello', 'hello')
    index.add thing.new(5, 'hello', 'hello', 'hello', 'hello')
    index.add thing.new(6, 'hello', 'hello', 'hello', 'hello')

    try = Picky::Search.new index
    try.search('hello').ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5]

    try = Picky::Search.new index
    try.search('hello', 30).ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1]

    try = Picky::Search.new index do
      terminate_early
    end
    try.search('hello', 3).ids.should == [6, 5, 4]

    try = Picky::Search.new index do
      terminate_early
    end
    try.search('hello', 9).ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4]

    try = Picky::Search.new index do
      terminate_early with_extra_allocations: 0
    end
    try.search('hello', 9).ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4]
    try.search('hello', 9, 4).ids.should ==          [2, 1, 6, 5, 4, 3, 2, 1, 6]
    try.search('hello', 9, 7).ids.should ==                   [5, 4, 3, 2, 1, 6, 5, 4, 3]
    try.search('hello', 9, 10).ids.should ==                           [2, 1, 6, 5, 4, 3, 2, 1, 6]
    try.search('hello', 9, 13).ids.should ==                                    [5, 4, 3, 2, 1, 6, 5, 4, 3]
    try.search('hello', 9, 16).ids.should ==                                             [2, 1, 6, 5, 4, 3, 2, 1]
    try.search('hello', 9, 19).ids.should ==                                                      [5, 4, 3, 2, 1]
    try.search('hello', 9, 22).ids.should ==                                                               [2, 1]
    try.search('hello', 9, 25).ids.should ==                                                                     []

    try.search('hello', 9).to_hash[:allocations].size.should == 2
    try.search('hello', 9, 4).to_hash[:allocations].size.should == 3
    try.search('hello', 9, 7).to_hash[:allocations].size.should == 3
    try.search('hello', 9, 10).to_hash[:allocations].size.should == 4
    try.search('hello', 9, 13).to_hash[:allocations].size.should == 4
    try.search('hello', 9, 16).to_hash[:allocations].size.should == 4
    try.search('hello', 9, 19).to_hash[:allocations].size.should == 4
    try.search('hello', 9, 22).to_hash[:allocations].size.should == 4
    try.search('hello', 9, 25).to_hash[:allocations].size.should == 4


    try = Picky::Search.new index do
      terminate_early 0
    end
    try.search('hello').ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5]

    try = Picky::Search.new index do
      terminate_early with_extra_allocations: 0
    end
    try.search('hello').ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5]

    try = Picky::Search.new index do
      terminate_early 2
    end
    try.search('hello', 13).ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6]
    try.search('hello', 13, 4).ids.should ==          [2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2]
    try.search('hello', 13, 8).ids.should ==                      [4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4]
    try.search('hello', 13, 12).ids.should ==                                 [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1]
    try.search('hello', 13, 16).ids.should ==                                             [2, 1, 6, 5, 4, 3, 2, 1]

    try.search('hello', 13).to_hash[:allocations].size.should == 3
    try.search('hello', 13, 4).to_hash[:allocations].size.should == 3
    try.search('hello', 13, 8).to_hash[:allocations].size.should == 4
    try.search('hello', 13, 12).to_hash[:allocations].size.should == 4
    try.search('hello', 13, 16).to_hash[:allocations].size.should == 4

    try = Picky::Search.new index do
      terminate_early with_extra_allocations: 2
    end
    try.search('hello').ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5]

    try = Picky::Search.new index do
      terminate_early with_extra_allocations: 1234
    end
    try.search('hello').ids.should == [6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5, 4, 3, 2, 1, 6, 5]

    try = Picky::Search.new index do
      terminate_early 1
    end
    try.search('hello', 1).ids.should == [6]
    try.search('hello', 1, 4).ids.should ==          [2]
    try.search('hello', 1, 8).ids.should ==                      [4]
    try.search('hello', 1, 12).ids.should ==                                 [6]
    try.search('hello', 1, 16).ids.should ==                                             [2]

    try.search('hello', 1).to_hash[:allocations].size.should == 2
    try.search('hello', 1, 4).to_hash[:allocations].size.should == 2
    try.search('hello', 1, 8).to_hash[:allocations].size.should == 2
    try.search('hello', 1, 12).to_hash[:allocations].size.should == 3
    try.search('hello', 1, 16).to_hash[:allocations].size.should == 3
    try.search('hello', 1, 20).to_hash[:allocations].size.should == 4
    try.search('hello', 1, 24).to_hash[:allocations].size.should == 4

    GC.start

    try_slow = Picky::Search.new index
    slow = performance_of do
      try_slow.search 'hello'
    end
    try_fast = Picky::Search.new index do
      terminate_early
    end
    fast = performance_of do
      try_fast.search 'hello'
    end
    (slow/fast).should >= 1.1

    try_slow = Picky::Search.new index
    slow = performance_of do
      try_slow.search 'hello hello'
    end
    try_fast = Picky::Search.new index do
      terminate_early
    end
    fast = performance_of do
      try_fast.search 'hello hello'
    end
    (slow/fast).should >= 1.4

    try_slow = Picky::Search.new index
    slow = performance_of do
      try_slow.search 'hello hello hello'
    end
    try_fast = Picky::Search.new index do
      terminate_early
    end
    fast = performance_of do
      try_fast.search 'hello hello hello'
    end
    (slow/fast).should >= 1.8

    try_slow = Picky::Search.new index
    slow = performance_of do
      try_slow.search 'hello hello hello hello'
    end
    try_fast = Picky::Search.new index do
      terminate_early
    end
    fast = performance_of do
      try_fast.search 'hello hello hello hello'
    end
    (slow/fast).should >= 2.0
  end

end