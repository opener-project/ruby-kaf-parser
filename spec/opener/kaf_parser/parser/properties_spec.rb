require 'spec_helper'

describe Opener::KafParser::Parser do
  let(:first_node) { @ast.children[0] }

  before :all do
    parser = Opener::KafParser::Parser.new
    @ast   = parser.parse(fixture('properties.kaf'))
  end

  context 'properties' do
    example 'set the property of a word' do
      node = @ast.children[107]

      node.id.should       == 'w109'
      node.property.should == 'value_for_money'
    end
  end
end
