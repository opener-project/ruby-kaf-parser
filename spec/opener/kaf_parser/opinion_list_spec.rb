require 'spec_helper'

describe Opener::KafParser::OpinionList do
  let(:opinion) { @opinions[0] }

  before :all do
    parser    = Opener::KafParser::Parser.new
    document  = parser.parse(fixture('input.kaf'))
    instance  = Opener::KafParser::OpinionList.new(document)
    @opinions = instance.construct
  end

  example 'set the opinion holder' do
    opinion.holder[0].id.should    == 'w1'
    opinion.holder[0].value.should == 'You'
  end

  example 'set the opinion target' do
    opinion.target[0].id.should    == 'w1'
    opinion.target[0].value.should == 'You'
  end

  example 'set the polarity of an opinion' do
    opinion.polarity.should == 'negative'
    opinion.strength.should == 1
  end

  example 'set the expression of an opinion' do
    values = opinion.expression.map(&:value)

    values.should == %w{you 'll need a prescription}
  end
end
