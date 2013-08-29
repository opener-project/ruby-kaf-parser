require 'spec_helper'

describe Opener::KafParser::Node::Opinion do
  let(:type_class) { Opener::KafParser::Node::Opinion }

  example 'set the ID via the constructor' do
    type_class.new(:id => 'o_1').id.should == 'o_1'
  end

  example 'set a positive polarity' do
    type_class.new(:polarity => 'positive').positive?.should == true
  end

  example 'set a negative polarity' do
    type_class.new(:polarity => 'negative').negative?.should == true
  end
end
