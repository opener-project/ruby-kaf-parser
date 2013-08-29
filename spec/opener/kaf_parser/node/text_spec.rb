require 'spec_helper'

describe Opener::KafParser::Node::Text do
  let(:type_class) { Opener::KafParser::Node::Text }

  context 'setting values via the constructor' do
    example 'setting the value' do
      type_class.new(:value => 'Hello').value.should == 'Hello'
    end

    example 'setting the polarity' do
      node = type_class.new(:polarity => 'positive')

      node.polarity.should == 'positive'
    end

    example 'setting the polarity strength' do
      node = type_class.new(:strength => 'weak')

      node.strength.should == 'weak'
    end

    example 'setting the polarity modifier' do
      node = type_class.new(:modifier => 'intensifier')

      node.modifier.should == 'intensifier'
    end

    example 'setting the entity' do
      node = type_class.new(:entity => 'location')

      node.entity.should == 'location'
    end

    example 'setting the opinion expression ID' do
      node = type_class.new(:opinion_expression_id => '1')

      node.opinion_expression_id.should == '1'
    end

    example 'setting the sentence number' do
      node = type_class.new(:sentence => 2)

      node.sentence.should == 2
    end

    example 'setting the word form ID' do
      type_class.new(:id => 'w1').id.should == 'w1'
    end

    example 'setting the POS' do
      type_class.new(:pos => 'A').pos.should == 'A'
    end
  end

  context 'shortcut methods' do
    example 'checking if the polarity is positive' do
      node = type_class.new(:polarity => 'positive')

      node.positive?.should == true
    end

    example 'checking if the polarity is negative' do
      node = type_class.new(:polarity => 'negative')

      node.negative?.should == true
    end
  end
end
