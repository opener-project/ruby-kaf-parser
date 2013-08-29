require 'spec_helper'

describe Opener::KafParser::Node::Base do
  before :all do
    @type = Class.new(Opener::KafParser::Node::Base) do
      attr_reader :number
    end
  end

  example 'ignore an attribute that does not have a reader method' do
    instance = @type.new(:foo => 'bar')

    instance.instance_variable_get(:@foo).nil?.should == true
  end

  example 'set an attribute that does have a reader method' do
    @type.new(:number => 10).number.should == 10
  end
end
