require 'spec_helper'

describe Opener::KafParser::TextConstructor do
  let(:constructor) { Opener::KafParser::TextConstructor }

  before :all do
    @nodes = [
      Opener::KafParser::AST::Text.new(
        :value  => 'Hello',
        :length => 5,
        :offset => 0
      ),
      Opener::KafParser::AST::Text.new(
        :value  => 'world',
        :length => 5,
        :offset => 6
      )
    ]
  end

  example 'reconstruct part of a text including whitespace' do
    constructor.new(@nodes).construct.should == 'Hello world'
  end
end
