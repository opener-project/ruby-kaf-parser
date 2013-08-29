require 'spec_helper'

describe Opener::KafParser::TextList do
  before :all do
    parser   = Opener::KafParser::Parser.new
    document = parser.parse(fixture('input.kaf'))
    instance = Opener::KafParser::TextList.new(document)
    @nodes   = instance.construct
  end

  example 'setting basic node information' do
    node = @nodes[0]

    node.sentence.should == 1
    node.id.should       == 'w1'
    node.value.should    == 'You'
  end

  example 'set the offset and length of a node' do
    node = @nodes[0]

    node.offset.should == 0
    node.length.should == 3
  end

  example 'setting the node Part Of Speech' do
    @nodes[0].pos.should == 'Q'
  end

  example 'setting the sentiment intensifier' do
    node = @nodes[10]

    node.id.should       == 'w11'
    node.value.should    == 'most'
    node.modifier.should == 'intensifier'
  end
end
