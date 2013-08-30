require 'spec_helper'

describe Opener::KafParser::Parser do
  let(:first_node) { @ast.children[0] }

  before :all do
    parser = Opener::KafParser::Parser.new
    @ast   = parser.parse(fixture('input.kaf'))
  end

  context 'root document' do
    example 'set the language' do
      @ast.language.should == 'en'
    end

    example 'set the version' do
      @ast.version.should  == 'v1.opener'
    end
  end

  context 'word forms' do
    example 'set the word ID' do
      first_node.id.should == 'w1'
    end

    example 'set the sentence number' do
      first_node.sentence.should == 1
    end

    example 'set the paragraph number' do
      first_node.paragraph.should == 1
    end

    example 'set the character offset' do
      first_node.offset.should == 0
    end

    example 'set the length' do
      first_node.length.should == 3
    end

    example 'set the value' do
      first_node.value.should == 'You'
    end
  end

  context 'terms' do
    example 'set the word word_type' do
      first_node.word_type.should == 'close'
    end

    example 'set the POS' do
      first_node.pos.should == 'Q'
    end

    example 'set the morphofeat' do
      first_node.morphofeat.should == 'PRP'
    end

    example 'set the sentiment modifier' do
      first_node.sentiment_modifier.should == 'intensifier'
    end

    example 'set the polarity' do
      first_node.polarity.should == 'negative'
    end
  end

  context 'opinions' do
    let(:first_opinion) { @ast.children[15] }

    example 'set the opinion ID' do
      first_opinion.id.should == 'o_1'
    end

    example 'set the opinion holders' do
      first_opinion.holder[0].id.should    == 'w1'
      first_opinion.holder[0].value.should == 'You'
    end

    example 'set the opinion target' do
      first_opinion.target[0].id.should    == 'w1'
      first_opinion.target[0].value.should == 'You'
    end

    example 'set the opinion polarity' do
      first_opinion.polarity.should == 'negative'
      first_opinion.strength.should == 1
    end

    example 'set the opinion expression' do
      first_opinion.children.length.should == 5

      first_opinion.children[0].id.should == 'w16'
      first_opinion.children[1].id.should == 'w17'
      first_opinion.children[2].id.should == 'w18'
    end
  end
end
