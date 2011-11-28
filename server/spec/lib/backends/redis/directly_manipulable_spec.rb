require 'spec_helper'

describe Picky::Backends::Redis::DirectlyManipulable do

  let(:client) { stub :client }
  let(:backend) { stub :backend, client: client, namespace: 'some:namespace' }
  let(:list) do
    described_class.make [1,2], backend, 'some:key'
  end

  context 'stubbed backend' do
    before(:each) do
      backend.stub! :[]
    end
    it 'calls the right client method' do
      client.should_receive(:zadd).once.with "some:namespace:some:key", :'0', 3

      list << 3
    end
    it 'calls the right client method' do
      client.should_receive(:zadd).once.with "some:namespace:some:key", :'0', 3

      list.unshift 3
    end
    it 'calls the right client method' do
      client.should_receive(:zrem).once.with "some:namespace:some:key", 1

      list.delete 1
    end
    it 'calls the right client method' do
      client.should_receive(:zrem).never

      list.delete 5
    end
  end

  context 'stubbed client' do
    before(:each) do
      client.stub! :zadd
      client.stub! :zrem
    end
    it 'calls [] at the end of the method' do
      backend.should_receive(:[]).once.with 'some:key'

      list << 3
    end
    it 'calls [] at the end of the method' do
      backend.should_receive(:[]).once.with 'some:key'

      list.unshift 3
    end
    it 'returns the result' do
      list.delete(1).should == 1
    end
  end

  context 'stubbed client/backend' do
    before(:each) do
      backend.stub! :[]
      client.stub! :zadd
      client.stub! :zrem
    end
    it 'behaves like an ordinary Array' do
      list << 3

      list.should == [1,2,3]
    end
    it 'behaves like an ordinary Array' do
      list.unshift 3

      list.should == [3,1,2]
    end
    it 'behaves like an ordinary Array' do
      list.delete 1

      list.should == [2]
    end
    it 'behaves like an ordinary Array' do
      list.delete 5

      list.should == [1,2]
    end
  end

end